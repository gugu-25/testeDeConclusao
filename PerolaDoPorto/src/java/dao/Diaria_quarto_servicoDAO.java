package model;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Diaria_quarto_servicoDAO extends DataBaseDAO {

    public Diaria_quarto_servicoDAO() throws ClassNotFoundException {
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
            Logger.getLogger(Diaria_quarto_servicoDAO.class.getName()).log(Level.SEVERE, null, e);
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
            Logger.getLogger(Diaria_quarto_servicoDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return sucesso;
    }

    public ArrayList<Diaria_quarto_servico> servicosVinculadosPorDiariaQuarto(int idDiaria, int idQuarto) {
        ArrayList<Diaria_quarto_servico> lista = new ArrayList<>();
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
                        Diaria_quarto_servico dqs = new Diaria_quarto_servico();
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
            Logger.getLogger(Diaria_quarto_servicoDAO.class.getName()).log(Level.SEVERE, null, e);
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
            Logger.getLogger(Diaria_quarto_servicoDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return lista;
    }
    
    public Diaria_quarto_servico getCarregaServicosPorDiariaQuarto(int idDiaria, int idQuarto) {
        Diaria_quarto_servico dqs = new Diaria_quarto_servico();
        
        Diaria_quarto dq = new Diaria_quarto();
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