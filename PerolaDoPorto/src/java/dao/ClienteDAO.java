package model;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ClienteDAO extends DataBaseDAO {

    public ClienteDAO() throws ClassNotFoundException {
    }

    public ArrayList<Cliente> getLista() {
        ArrayList<Cliente> lista = new ArrayList<>();
        String sql = "SELECT * FROM cliente";
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql);
                 ResultSet rs = pstm.executeQuery()) {
                while (rs.next()) {
                    Cliente c = new Cliente();
                    c.setIdCliente(rs.getInt("idCliente"));
                    c.setNomeRazao(rs.getString("nomeRazao"));
                    c.setCpfCnpj(rs.getString("cpfCnpj"));
                    c.setRgIe(rs.getString("rgIe"));
                    c.setDataNascAbertura(rs.getDate("dataNascAbertura"));
                    c.setTipo(rs.getInt("tipo"));
                    c.setStatus(rs.getInt("status"));
                    
                    lista.add(c);
                }  
            }    
        } catch (SQLException e) {
            Logger.getLogger(ClienteDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return lista;
    }

    public Cliente getCarregaPorID(int idCliente) {
        Cliente c = new Cliente();
        String sql = "SELECT * FROM cliente WHERE idCliente=?";
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setInt(1, idCliente);    
                try (ResultSet rs = pstm.executeQuery()) {
                    if (rs.next()) {
                        c = new Cliente();
                        c.setIdCliente(rs.getInt("idCliente"));
                        c.setNomeRazao(rs.getString("nomeRazao"));
                        c.setCpfCnpj(rs.getString("cpfCnpj"));
                        c.setRgIe(rs.getString("rgIe"));
                        c.setDataNascAbertura(rs.getDate("dataNascAbertura"));
                        c.setTipo(rs.getInt("tipo"));
                        c.setStatus(rs.getInt("status"));
                    }  
                }            
            }    
        } catch (SQLException e) {
            Logger.getLogger(ClienteDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return c;
    }

    public boolean gravar(Cliente c) {
        boolean sucesso = false;
        String sql;
        if (c.getIdCliente() == 0) {
            sql = "INSERT INTO cliente(nomeRazao, cpfCnpj, rgIe, dataNascAbertura, tipo, status) VALUES(?,?,?,?,?,?)";
        } else {
            sql = "UPDATE cliente SET nomeRazao=?, cpfCnpj=?, rgIe=?, dataNascAbertura=?, tipo=?, status=? WHERE idCliente=?";
        }
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setString(1, c.getNomeRazao());
                pstm.setString(2, c.getCpfCnpj());
                pstm.setString(3, c.getRgIe());
                if (c.getDataNascAbertura() != null) {
                    pstm.setDate(4, new Date(c.getDataNascAbertura().getTime()));
                } else {
                    pstm.setNull(4, java.sql.Types.DATE);
                }
                pstm.setInt(5, c.getTipo());
                pstm.setInt(6, c.getStatus());
                
                if (c.getIdCliente() > 0) {
                    pstm.setInt(7, c.getIdCliente());
                }
                
                int rowsAffected = pstm.executeUpdate();
                if (rowsAffected > 0) {
                    sucesso = true;
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(ClienteDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return sucesso;
    }

    public boolean desativar(Cliente c) {
        boolean sucesso = false;
        try {
            this.conectar();
            String sql = "UPDATE cliente SET status=2 WHERE idCliente=?";
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setInt(1, c.getIdCliente());
                int rowsAffected = pstm.executeUpdate();
                if (rowsAffected > 0) {
                    sucesso = true;
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(ClienteDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return sucesso;
    }

}