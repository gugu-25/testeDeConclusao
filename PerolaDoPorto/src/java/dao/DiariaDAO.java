package model;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DiariaDAO extends DataBaseDAO {

    public DiariaDAO() throws ClassNotFoundException {
    }
    
    public ArrayList<Diaria> getLista() {
        ArrayList<Diaria> lista = new ArrayList<>();
        String sql = "SELECT * FROM diaria";
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql);
                 ResultSet rs = pstm.executeQuery()) {
                while (rs.next()) {
                    Diaria d = new Diaria();
                    d.setIdDiaria(rs.getInt("idDiaria"));
                    d.setValorDiaria(rs.getDouble("valorDiaria"));
                    d.setDescricao(rs.getString("descricao"));
                    d.setStatusHospedagem(rs.getInt("statusHospedagem"));
                    d.setValorTotal(rs.getDouble("valorTotal"));
                    d.setStatusPagamento(rs.getInt("statusPagamento"));
                    d.setFeitoEm(rs.getDate("feitoEm"));
                    d.setPagoEm(rs.getDate("pagoEm"));
                    
                    try {
                        ClienteDAO cDAO = new ClienteDAO();
                        d.setCliente(cDAO.getCarregaPorID(rs.getInt("cliente_idCliente")));
                        
                        UsuarioDAO uDAO = new UsuarioDAO();
                        d.setUsuario(uDAO.getCarregaPorID(rs.getInt("usuario_idUsuario")));
                        
                        int idPendencia = rs.getInt("pendencias_idPendencias");
                        if (!rs.wasNull()) {
                            PendenciasDAO pDAO = new PendenciasDAO();
                            d.setPendencias(pDAO.getCarregaPorID(idPendencia));
                        }
                        
                        DiariaQuartoDAO dqDAO = new DiariaQuartoDAO();
                        d.setCarrinhoQuarto(dqDAO.quartosVinculadosPorDiaria(d.getIdDiaria())); 
                        
                    } catch (ClassNotFoundException ex) {
                        Logger.getLogger(DiariaDAO.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    
                    lista.add(d);
                }  
            }    
        } catch (SQLException e) {
            Logger.getLogger(DiariaDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return lista;
    }
    
    public Diaria getCarregaPorID(int idDiaria) {
        Diaria d = new Diaria();
        String sql = "SELECT * FROM diaria WHERE idDiaria=?";
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setInt(1, idDiaria);    
                try (ResultSet rs = pstm.executeQuery()) {
                    if (rs.next()) {
                        d = new Diaria();
                        d.setIdDiaria(rs.getInt("idDiaria"));
                        d.setValorDiaria(rs.getDouble("valorDiaria"));
                        d.setDescricao(rs.getString("descricao"));
                        d.setStatusHospedagem(rs.getInt("statusHospedagem"));
                        d.setValorTotal(rs.getDouble("valorTotal"));
                        d.setStatusPagamento(rs.getInt("statusPagamento"));
                        d.setFeitoEm(rs.getDate("feitoEm"));
                        d.setPagoEm(rs.getDate("pagoEm"));
                        
                        try {
                            ClienteDAO cDAO = new ClienteDAO();
                            d.setCliente(cDAO.getCarregaPorID(rs.getInt("cliente_idCliente")));
                            
                            UsuarioDAO uDAO = new UsuarioDAO();
                            d.setUsuario(uDAO.getCarregaPorID(rs.getInt("usuario_idUsuario")));
                            
                            int idPendencia = rs.getInt("pendencias_idPendencias");
                            if (!rs.wasNull()) {
                                PendenciasDAO pDAO = new PendenciasDAO();
                                d.setPendencias(pDAO.getCarregaPorID(idPendencia));
                            }
                            
                            DiariaQuartoDAO dqDAO = new DiariaQuartoDAO();
                            d.setCarrinhoQuarto(dqDAO.quartosVinculadosPorDiaria(d.getIdDiaria())); 
                            
                        } catch (ClassNotFoundException ex) {
                            Logger.getLogger(DiariaDAO.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }  
                }            
            }    
        } catch (SQLException e) {
            Logger.getLogger(DiariaDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return d;
    }
    
    public boolean gravar(Diaria d) {
        boolean sucesso = false;
        boolean novaDiaria = d.getIdDiaria() == 0;
        String sql;
        if (novaDiaria) {
            sql = "INSERT INTO diaria(valorDiaria, descricao, statusHospedagem, valorTotal, statusPagamento, feitoEm, pagoEm, usuario_idUsuario, cliente_idCliente, pendencias_idPendencias) VALUES(?,?,?,?,?,?,?,?,?,?)";
        } else {
            sql = "UPDATE diaria SET valorDiaria=?, descricao=?, statusHospedagem=?, valorTotal=?, statusPagamento=?, feitoEm=?, pagoEm=?, usuario_idUsuario=?, cliente_idCliente=?, pendencias_idPendencias=? WHERE idDiaria=?";
        }
        
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                pstm.setDouble(1, d.getValorDiaria());
                pstm.setString(2, d.getDescricao());
                pstm.setInt(3, d.getStatusHospedagem());
                pstm.setDouble(4, d.getValorTotal());
                pstm.setInt(5, d.getStatusPagamento());
                
                if (d.getFeitoEm() != null) {
                    pstm.setDate(6, new Date(d.getFeitoEm().getTime()));
                } else {
                    pstm.setNull(6, Types.DATE);
                }
                
                if (d.getPagoEm() != null) {
                    pstm.setDate(7, new Date(d.getPagoEm().getTime()));
                } else {
                    pstm.setNull(7, Types.DATE);
                }
                
                pstm.setInt(8, d.getUsuario().getIdUsuario());
                pstm.setInt(9, d.getCliente().getIdCliente());
                
                if (d.getPendencias() != null && d.getPendencias().getIdPendencias() > 0) {
                    pstm.setInt(10, d.getPendencias().getIdPendencias());
                } else {
                    pstm.setNull(10, Types.INTEGER);
                }
                
                if (d.getIdDiaria() > 0) {
                    pstm.setInt(11, d.getIdDiaria());
                }
                
                int rowsAffected = pstm.executeUpdate();
                
                if (rowsAffected > 0) {
                    sucesso = true;
                    
                    if (novaDiaria) {
                        try (ResultSet rs = pstm.getGeneratedKeys()) {
                            if (rs.next()) {
                                d.setIdDiaria(rs.getInt(1)); 
                            }
                        }
                    }
                    
                    if (novaDiaria && d.getCarrinhoQuarto() != null && !d.getCarrinhoQuarto().isEmpty()) {
                        DiariaQuartoDAO dqDAO = new DiariaQuartoDAO();
                        
                        for (DiariaQuarto item : d.getCarrinhoQuarto()) {
                            dqDAO.vincular(d.getIdDiaria(), item.getQuarto().getIdQuarto(), item.getValorAtual(), item.getCheckIn(), item.getCheckOut()); 
                        }
                    }
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(DiariaDAO.class.getName()).log(Level.SEVERE, null, e);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(DiariaDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            this.desconectar();
        }
        return sucesso;
    }
    
    public boolean desativar(Diaria d) {
        boolean sucesso = false;
        try {
            this.conectar();
            String sql = "UPDATE diaria SET statusHospedagem=2 WHERE idDiaria=?";
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setInt(1, d.getIdDiaria());
                int rowsAffected = pstm.executeUpdate();
                if (rowsAffected > 0) {
                    sucesso = true;
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(DiariaDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return sucesso;
    }
}