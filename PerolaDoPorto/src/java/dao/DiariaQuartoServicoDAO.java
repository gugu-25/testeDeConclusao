package model;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DiariaQuartoServicoDAO extends DataBaseDAO {

    public DiariaQuartoServicoDAO() throws ClassNotFoundException {
    }

    public boolean vincular(int idDiaria, int idQuarto, int idServico, double valorServicoAtual) {
        boolean sucesso = false;
        String sql = "INSERT INTO diaria_quarto_servico (diaria_idDiaria, quarto_idQuarto, servico_idServico, valorServicoAtual) VALUES(?,?,?,?)";
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setInt(1, idDiaria);
                pstm.setInt(2, idQuarto);
                pstm.setInt(3, idServico);
                pstm.setDouble(4, valorServicoAtual);
                int rowsAffected = pstm.executeUpdate();
                if (rowsAffected > 0) {
                    sucesso = true;
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(DiariaQuartoServicoDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return sucesso;
    }

    public boolean desvincular(int idDiaria, int idQuarto, int idServico) {
        boolean sucesso = false;
        String sql = "DELETE FROM diaria_quarto_servico WHERE diaria_idDiaria=? AND quarto_idQuarto=? AND servico_idServico=?";
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setInt(1, idDiaria);
                pstm.setInt(2, idQuarto);
                pstm.setInt(3, idServico);
                int rowsAffected = pstm.executeUpdate();
                if (rowsAffected > 0) {
                    sucesso = true;
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(DiariaQuartoServicoDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return sucesso;
    }

    public boolean adicionarEmConta(int idDiaria, int idQuarto, Map<Integer, Integer> carrinho) {
        if (carrinho == null || carrinho.isEmpty()) {
            return false;
        }

        boolean sucesso = false;
        String disponibilidadeSql = "SELECT s.nome, s.valor FROM servico s "
                + "WHERE s.idServico=? AND s.status=1 "
                + "AND NOT EXISTS (SELECT 1 FROM diaria_quarto_servico dqs "
                + "WHERE dqs.diaria_idDiaria=? AND dqs.quarto_idQuarto=? "
                + "AND dqs.servico_idServico=s.idServico)";
        String vincularSql = "INSERT INTO diaria_quarto_servico "
                + "(diaria_idDiaria, quarto_idQuarto, servico_idServico, valorServicoAtual) "
                + "VALUES(?,?,?,?)";
        String pendenciaSql = "INSERT INTO pendencias "
                + "(descricao, valor, dataRegistro, status, "
                + "diaria_quarto_servico_diaria_quarto_diaria_idDiaria, "
                + "diaria_quarto_servico_diaria_quarto_idQuarto, "
                + "diaria_quarto_servico_servico_idServico) "
                + "VALUES(?,?,CURRENT_DATE(),1,?,?,?)";

        try {
            this.conectar();
            conn.setAutoCommit(false);
            try (PreparedStatement disponibilidade = conn.prepareStatement(disponibilidadeSql);
                 PreparedStatement vincular = conn.prepareStatement(vincularSql);
                 PreparedStatement criarPendencia = conn.prepareStatement(pendenciaSql)) {
                for (Map.Entry<Integer, Integer> item : carrinho.entrySet()) {
                    Integer idServico = item.getKey();
                    int quantidade = item.getValue() == null ? 0 : item.getValue();
                    if (quantidade < 1) {
                        throw new SQLException("Quantidade inválida no carrinho");
                    }
                    if (idServico == null || idServico <= 0) {
                        throw new SQLException("ID de serviço inválido no carrinho");
                    }

                    disponibilidade.setInt(1, idServico);
                    disponibilidade.setInt(2, idDiaria);
                    disponibilidade.setInt(3, idQuarto);
                    String nomeServico;
                    double valorServico;
                    try (ResultSet rs = disponibilidade.executeQuery()) {
                        if (!rs.next()) {
                            throw new SQLException("Serviço indisponível para esta diária");
                        }
                        nomeServico = rs.getString("nome");
                        valorServico = rs.getDouble("valor");
                    }
                    if (Double.isNaN(valorServico) || Double.isInfinite(valorServico) || valorServico < 0) {
                        throw new SQLException("O valor do serviço não pode ser negativo");
                    }

                    vincular.setInt(1, idDiaria);
                    vincular.setInt(2, idQuarto);
                    vincular.setInt(3, idServico);
                    vincular.setDouble(4, valorServico);
                    if (vincular.executeUpdate() != 1) {
                        throw new SQLException("Não foi possível vincular o serviço à diária");
                    }

                    criarPendencia.setString(1, "Serviço: " + nomeServico + " (x" + quantidade + ")");
                    criarPendencia.setDouble(2, valorServico * quantidade);
                    criarPendencia.setInt(3, idDiaria);
                    criarPendencia.setInt(4, idQuarto);
                    criarPendencia.setInt(5, idServico);
                    if (criarPendencia.executeUpdate() != 1) {
                        throw new SQLException("Não foi possível lançar o serviço como pendência");
                    }
                }
            }
            conn.commit();
            sucesso = true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackError) {
                    Logger.getLogger(DiariaQuartoServicoDAO.class.getName())
                            .log(Level.SEVERE, "Falha ao desfazer a inclusão dos serviços", rollbackError);
                }
            }
            Logger.getLogger(DiariaQuartoServicoDAO.class.getName())
                    .log(Level.SEVERE, "Falha ao adicionar serviços à conta da diária", e);
        } finally {
            this.desconectar();
        }
        return sucesso;
    }

    public ArrayList<DiariaQuartoServico> servicosVinculadosPorDiariaQuarto(int idDiaria, int idQuarto) {
        ArrayList<DiariaQuartoServico> lista = new ArrayList<>();
        String sql = "SELECT dqs.*, s.* FROM diaria_quarto_servico as dqs, servico as s "
                   + " WHERE dqs.servico_idServico = s.idServico "
                   + " AND dqs.diaria_idDiaria=? AND dqs.quarto_idQuarto=?";
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setInt(1, idDiaria);
                pstm.setInt(2, idQuarto);
                try (ResultSet rs = pstm.executeQuery()) {
                    while (rs.next()) {
                        DiariaQuartoServico dqs = new DiariaQuartoServico();
                        dqs.setValorServicoAtual(rs.getDouble("dqs.valorServicoAtual"));
                        
                        Servico s = new Servico();
                        s.setIdServico(rs.getInt("s.idServico"));
                        s.setNome(rs.getString("s.nome"));
                        s.setValor(rs.getDouble("s.valor"));
                        s.setStatus(rs.getInt("s.status"));
                        
                        dqs.setServico(s);
                        lista.add(dqs);
                    }
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(DiariaQuartoServicoDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return lista;
    }

    public ArrayList<Servico> servicosNaoVinculadosPorDiariaQuarto(int idDiaria, int idQuarto) {
        ArrayList<Servico> lista = new ArrayList<>();
        String sql = "SELECT s.* FROM servico as s "
                   + " WHERE s.idServico "
                   + " NOT IN (SELECT servico_idServico FROM diaria_quarto_servico "
                   + "         WHERE diaria_idDiaria=? AND quarto_idQuarto=?) AND s.status = 1"; 
        
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setInt(1, idDiaria);
                pstm.setInt(2, idQuarto);
                try (ResultSet rs = pstm.executeQuery()) {
                    while (rs.next()) {
                        Servico s = new Servico();
                        s.setIdServico(rs.getInt("idServico"));
                        s.setNome(rs.getString("nome"));
                        s.setValor(rs.getDouble("valor"));
                        s.setStatus(rs.getInt("status"));
                        
                        lista.add(s);
                    }
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(DiariaQuartoServicoDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return lista;
    }
    
    public DiariaQuartoServico getCarregaServicosPorDiariaQuarto(int idDiaria, int idQuarto) {
        DiariaQuartoServico dqs = new DiariaQuartoServico();
        
        DiariaQuarto dq = new DiariaQuarto();
        Diaria d = new Diaria();
        d.setIdDiaria(idDiaria);
        Quarto q = new Quarto();
        q.setIdQuarto(idQuarto);
        dq.setDiaria(d);
        dq.setQuarto(q);
        dqs.setDiariaQuarto(dq);
        
        dqs.setServicosVinculados(servicosVinculadosPorDiariaQuarto(idDiaria, idQuarto));
        dqs.setServicosNaoVinculados(servicosNaoVinculadosPorDiariaQuarto(idDiaria, idQuarto));
        
        return dqs;
    }
}