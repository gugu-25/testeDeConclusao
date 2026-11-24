package model;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;


public class ServicoDAO extends DataBaseDAO {

    public ServicoDAO() throws ClassNotFoundException {
    }
    
    public ArrayList<Servico> getLista() {
        ArrayList<Servico> lista = new ArrayList<>();
        String sql = "SELECT * FROM servico";
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql);
                 ResultSet rs = pstm.executeQuery()) {
                while (rs.next()) {
                    Servico s = new Servico();
                    s.setIdServico(rs.getInt("idServico"));
                    s.setNome(rs.getString("nome"));
                    s.setValor(rs.getDouble("valor"));
                    s.setStatus(rs.getInt("status"));
                    
                    lista.add(s);
                }  
            }    
        } catch (SQLException e) {
            Logger.getLogger(ServicoDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return lista;
    }
    
    public Servico getCarregaPorID(int idServico) {
        Servico s = new Servico();
        String sql = "SELECT * FROM servico WHERE idServico=?";
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setInt(1, idServico);    
                try (ResultSet rs = pstm.executeQuery()) {
                    if (rs.next()) {
                        s = new Servico();
                        s.setIdServico(rs.getInt("idServico"));
                        s.setNome(rs.getString("nome"));
                        s.setValor(rs.getDouble("valor"));
                        s.setStatus(rs.getInt("status"));
                    }  
                }            
            }    
        } catch (SQLException e) {
            Logger.getLogger(ServicoDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return s;
    }
    
    public boolean gravar(Servico s) {
        boolean sucesso = false;
        String sql;
        if (s.getIdServico() == 0) {
            sql = "INSERT INTO servico(nome,valor,status) VALUES(?,?,?)";
        } else {
            sql = "UPDATE servico SET nome=?, valor=?, status=? WHERE idServico=?";
        }
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setString(1, s.getNome());
                pstm.setDouble(2, s.getValor());
                pstm.setInt(3, s.getStatus());
                if (s.getIdServico() > 0) {
                    pstm.setInt(4, s.getIdServico());
                }
                int rowsAffected = pstm.executeUpdate();
                if (rowsAffected > 0) {
                    sucesso = true;
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(ServicoDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return sucesso;
    }
    
    public boolean desativar(Servico s) {
        boolean sucesso = false;
        try {
            this.conectar();
            String sql = "UPDATE servico SET status=2 WHERE idServico=?";
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setInt(1, s.getIdServico());
                int rowsAffected = pstm.executeUpdate();
                if (rowsAffected > 0) {
                    sucesso = true;
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(ServicoDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return sucesso;
    }

    public boolean excluir(int idServico) {
        boolean sucesso = false;
        String sql = "DELETE FROM servico WHERE idServico=? "
                + "AND NOT EXISTS (SELECT 1 FROM diaria_quarto_servico "
                + "WHERE servico_idServico=?)";
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setInt(1, idServico);
                pstm.setInt(2, idServico);
                sucesso = pstm.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            Logger.getLogger(ServicoDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return sucesso;
    }
    
}