package model;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

public class QuartoDAO extends DataBaseDAO {

    public QuartoDAO() throws ClassNotFoundException {
    }
    
    public ArrayList<Quarto> getLista() {
        ArrayList<Quarto> lista = new ArrayList<>();
        String sql = "SELECT * FROM quarto";
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql);
                 ResultSet rs = pstm.executeQuery()) {
                while (rs.next()) {
                    Quarto q = new Quarto();
                    q.setIdQuarto(rs.getInt("idQuarto"));
                    q.setNumero(rs.getInt("numero"));
                    q.setTipo(rs.getInt("tipo"));
                    q.setDescricao(rs.getString("descricao"));
                    q.setValor(rs.getDouble("valor"));
                    q.setStatus(rs.getInt("status")); 
                    
                    lista.add(q);
                }  
            }    
        } catch (SQLException e) {
            Logger.getLogger(QuartoDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return lista;
    }
    
    public Quarto getCarregaPorID(int idQuarto) {
        Quarto q = new Quarto();
        String sql = "SELECT * FROM quarto WHERE idQuarto=?";
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setInt(1, idQuarto);    
                try (ResultSet rs = pstm.executeQuery()) {
                    if (rs.next()) {
                        q = new Quarto();
                        q.setIdQuarto(rs.getInt("idQuarto"));
                        q.setNumero(rs.getInt("numero"));
                        q.setTipo(rs.getInt("tipo"));
                        q.setDescricao(rs.getString("descricao"));
                        q.setValor(rs.getDouble("valor"));
                        q.setStatus(rs.getInt("status")); 
                    }  
                }            
            }    
        } catch (SQLException e) {
            Logger.getLogger(QuartoDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return q;
    }

    public boolean numeroEmUso(int numero, int idQuarto) throws SQLException {
        String sql = "SELECT 1 FROM quarto WHERE numero=? AND idQuarto<>? LIMIT 1";
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setInt(1, numero);
                pstm.setInt(2, idQuarto);
                try (ResultSet rs = pstm.executeQuery()) {
                    return rs.next();
                }
            }
        } finally {
            this.desconectar();
        }
    }
    
    public boolean gravar(Quarto q) {
        boolean sucesso = false;
        String sql;
        if (q.getIdQuarto() == 0) {
            sql = "INSERT INTO quarto(numero,tipo,descricao,valor,status) VALUES(?,?,?,?,?)";
        } else {
            sql = "UPDATE quarto SET numero=?, tipo=?, descricao=?, valor=?, status=? WHERE idQuarto=?";
        }
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setInt(1, q.getNumero());
                pstm.setInt(2, q.getTipo());
                pstm.setString(3, q.getDescricao());
                pstm.setDouble(4, q.getValor());
                pstm.setInt(5, q.getStatus()); 
                
                if (q.getIdQuarto() > 0) {
                    pstm.setInt(6, q.getIdQuarto());
                }
                int rowsAffected = pstm.executeUpdate();
                if (rowsAffected > 0) {
                    sucesso = true;
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(QuartoDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return sucesso;
    }
    
    public boolean desativar(Quarto q) {
        boolean sucesso = false;
        try {
            this.conectar();
            String sql = "UPDATE quarto SET status=2 WHERE idQuarto=?";
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setInt(1, q.getIdQuarto());
                int rowsAffected = pstm.executeUpdate();
                if (rowsAffected > 0) {
                    sucesso = true;
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(QuartoDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return sucesso;
    }
    
}