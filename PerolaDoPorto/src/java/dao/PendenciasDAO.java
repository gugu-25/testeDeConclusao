package model;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PendenciasDAO extends DataBaseDAO {

    public PendenciasDAO() throws ClassNotFoundException {
    }

    public ArrayList<Pendencias> getLista() {
        ArrayList<Pendencias> lista = new ArrayList<>();
        String sql = "SELECT p.*, dqs.diaria_idDiaria AS diariaId, "
                   + "dqs.quarto_idQuarto AS quartoId, dqs.servico_idServico AS servicoId, "
                   + "c.nomeRazao AS nomeCliente, q.numero AS numeroQuarto, s.nome AS nomeServico "
                   + "FROM pendencias p "
                   + "LEFT JOIN diaria_quarto_servico dqs "
                   + "ON dqs.diaria_idDiaria = p.diaria_quarto_servico_diaria_quarto_diaria_idDiaria "
                   + "AND dqs.quarto_idQuarto = p.diaria_quarto_servico_diaria_quarto_idQuarto "
                   + "AND dqs.servico_idServico = p.diaria_quarto_servico_servico_idServico "
                   + "LEFT JOIN diaria d ON d.idDiaria = dqs.diaria_idDiaria "
                   + "LEFT JOIN cliente c ON c.idCliente = d.cliente_idCliente "
                   + "LEFT JOIN quarto q ON q.idQuarto = dqs.quarto_idQuarto "
                   + "LEFT JOIN servico s ON s.idServico = dqs.servico_idServico";
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql);
                 ResultSet rs = pstm.executeQuery()) {
                while (rs.next()) {
                    Pendencias p = new Pendencias();
                    p.setIdPendencias(rs.getInt("idPendencias"));
                    p.setDescricao(rs.getString("descricao"));
                    p.setValor(rs.getDouble("valor"));
                    p.setDataRegistro(rs.getDate("dataRegistro"));
                    p.setStatus(rs.getInt("status"));
                    
                    DiariaQuartoServico dqs = new DiariaQuartoServico();
                    DiariaQuarto dq = new DiariaQuarto();
                    Diaria diaria = new Diaria();
                    Quarto quarto = new Quarto();
                    Servico servico = new Servico();
                    
                    diaria.setIdDiaria(rs.getInt("diariaId"));
                    Cliente cliente = new Cliente();
                    cliente.setNomeRazao(rs.getString("nomeCliente"));
                    diaria.setCliente(cliente);
                    quarto.setIdQuarto(rs.getInt("quartoId"));
                    quarto.setNumero(rs.getInt("numeroQuarto"));
                    servico.setIdServico(rs.getInt("servicoId"));
                    servico.setNome(rs.getString("nomeServico"));
                    
                    dq.setDiaria(diaria);
                    dq.setQuarto(quarto);
                    dqs.setDiariaQuarto(dq);
                    dqs.setServico(servico);
                    
                    p.setDiariaQuartoServico(dqs);
                    lista.add(p);
                }  
            }    
        } catch (SQLException e) {
            Logger.getLogger(PendenciasDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return lista;
    }

    public Pendencias getCarregaPorID(int idPendencias) {
        Pendencias p = new Pendencias();
        String sql = "SELECT * FROM pendencias WHERE idPendencias=?";
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setInt(1, idPendencias);    
                try (ResultSet rs = pstm.executeQuery()) {
                    if (rs.next()) {
                        p = new Pendencias();
                        p.setIdPendencias(rs.getInt("idPendencias"));
                        p.setDescricao(rs.getString("descricao"));
                        p.setValor(rs.getDouble("valor"));
                        p.setDataRegistro(rs.getDate("dataRegistro"));
                        p.setStatus(rs.getInt("status"));
                        
                        DiariaQuartoServico dqs = new DiariaQuartoServico();
                        DiariaQuarto dq = new DiariaQuarto();
                        Diaria diaria = new Diaria();
                        Quarto quarto = new Quarto();
                        Servico servico = new Servico();
                        
                        diaria.setIdDiaria(rs.getInt("diaria_quarto_servico_diaria_quarto_diaria_idDiaria"));
                        quarto.setIdQuarto(rs.getInt("diaria_quarto_servico_diaria_quarto_idQuarto"));
                        servico.setIdServico(rs.getInt("diaria_quarto_servico_servico_idServico"));
                        
                        dq.setDiaria(diaria);
                        dq.setQuarto(quarto);
                        dqs.setDiariaQuarto(dq);
                        dqs.setServico(servico);
                        
                        p.setDiariaQuartoServico(dqs);
                    }  
                }            
            }    
        } catch (SQLException e) {
            Logger.getLogger(PendenciasDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return p;
    }

    public boolean gravar(Pendencias p) {
        boolean sucesso = false;
        String sql;
        if (p.getIdPendencias() == 0) {
            sql = "INSERT INTO pendencias(descricao, valor, dataRegistro, status, diaria_quarto_servico_diaria_quarto_diaria_idDiaria, diaria_quarto_servico_diaria_quarto_idQuarto, diaria_quarto_servico_servico_idServico) VALUES(?,?,?,?,?,?,?)";
        } else {
            sql = "UPDATE pendencias SET descricao=?, valor=?, dataRegistro=?, status=?, diaria_quarto_servico_diaria_quarto_diaria_idDiaria=?, diaria_quarto_servico_diaria_quarto_idQuarto=?, diaria_quarto_servico_servico_idServico=? WHERE idPendencias=?";
        }
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setString(1, p.getDescricao());
                pstm.setDouble(2, p.getValor());
                pstm.setDate(3, new Date(p.getDataRegistro().getTime()));
                pstm.setInt(4, p.getStatus());
                
                pstm.setInt(5, p.getDiariaQuartoServico().getDiariaQuarto().getDiaria().getIdDiaria());
                pstm.setInt(6, p.getDiariaQuartoServico().getDiariaQuarto().getQuarto().getIdQuarto());
                pstm.setInt(7, p.getDiariaQuartoServico().getServico().getIdServico());
                
                if (p.getIdPendencias() > 0) {
                    pstm.setInt(8, p.getIdPendencias());
                }
                
                int rowsAffected = pstm.executeUpdate();
                if (rowsAffected > 0) {
                    sucesso = true;
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(PendenciasDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return sucesso;
    }

    public boolean desativar(Pendencias p) {
        boolean sucesso = false;
        try {
            this.conectar();
            String sql = "UPDATE pendencias SET status=2 WHERE idPendencias=?";
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setInt(1, p.getIdPendencias());
                int rowsAffected = pstm.executeUpdate();
                if (rowsAffected > 0) {
                    sucesso = true;
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(PendenciasDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return sucesso;
    }
}