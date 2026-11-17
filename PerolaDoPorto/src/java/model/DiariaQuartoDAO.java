package model;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DiariaQuartoDAO extends DataBaseDAO {

    public DiariaQuartoDAO() throws ClassNotFoundException {
    }

    public boolean vincular(int idDiaria, int idQuarto, double valorAtual, java.util.Date checkIn, java.util.Date checkOut) {
        boolean sucesso = false;
        String sql = "INSERT INTO diaria_quarto (diaria_idDiaria, quarto_idQuarto, valorAtual, checkIn, checkOut) VALUES(?,?,?,?,?)";
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setInt(1, idDiaria);
                pstm.setInt(2, idQuarto);
                pstm.setDouble(3, valorAtual);

                if (checkIn != null) {
                    pstm.setDate(4, new Date(checkIn.getTime()));
                } else {
                    pstm.setNull(4, Types.DATE);
                }

                if (checkOut != null) {
                    pstm.setDate(5, new Date(checkOut.getTime()));
                } else {
                    pstm.setNull(5, Types.DATE);
                }

                int rowsAffected = pstm.executeUpdate();
                if (rowsAffected > 0) {
                    sucesso = true;
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(DiariaQuartoDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return sucesso;
    }

    public boolean desvincular(int idDiaria, int idQuarto) {
        boolean sucesso = false;
        String sql = "DELETE FROM diaria_quarto WHERE diaria_idDiaria=? AND quarto_idQuarto=?";
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setInt(1, idDiaria);
                pstm.setInt(2, idQuarto);
                int rowsAffected = pstm.executeUpdate();
                if (rowsAffected > 0) {
                    sucesso = true;
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(DiariaQuartoDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return sucesso;
    }

    public ArrayList<DiariaQuarto> quartosVinculadosPorDiaria(int idDiaria) {
        ArrayList<DiariaQuarto> lista = new ArrayList<>();
        String sql = "SELECT dq.*, q.* FROM diaria_quarto as dq, quarto as q "
                   + " WHERE dq.quarto_idQuarto = q.idQuarto "
                   + " AND dq.diaria_idDiaria=?";
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setInt(1, idDiaria);
                try (ResultSet rs = pstm.executeQuery()) {
                    while (rs.next()) {
                        DiariaQuarto dq = new DiariaQuarto();
                        dq.setValorAtual(rs.getDouble("dq.valorAtual"));
                        dq.setCheckIn(rs.getDate("dq.checkIn"));
                        dq.setCheckOut(rs.getDate("dq.checkOut"));
                        
                        Quarto q = new Quarto();
                        q.setIdQuarto(rs.getInt("q.idQuarto"));
                        q.setNumero(rs.getInt("q.numero"));
                        q.setTipo(rs.getInt("q.tipo"));
                        q.setDescricao(rs.getString("q.descricao"));
                        q.setValor(rs.getDouble("q.valor"));
                        q.setStatus(rs.getInt("q.status"));
                        
                        dq.setQuarto(q);
                        
                        lista.add(dq);
                    }
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(DiariaQuartoDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return lista;
    }

    public ArrayList<Quarto> quartosNaoVinculadosPorDiaria(int idDiaria) {
        ArrayList<Quarto> lista = new ArrayList<>();
        String sql = "SELECT q.* FROM quarto as q "
                   + " WHERE q.idQuarto "
                   + " NOT IN (SELECT quarto_idQuarto FROM diaria_quarto "
                   + "         WHERE diaria_idDiaria=? ) AND q.status = 1"; 
        
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setInt(1, idDiaria);
                try (ResultSet rs = pstm.executeQuery()) {
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
            }
        } catch (SQLException e) {
            Logger.getLogger(DiariaQuartoDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return lista;
    }

    public DiariaQuarto getCarregaQuartosPorDiaria(int idDiaria) {
        DiariaQuarto dq = new DiariaQuarto();
        dq.setQuartosVinculados(quartosVinculadosPorDiaria(idDiaria));
        dq.setQuartosNaoVinculados(quartosNaoVinculadosPorDiaria(idDiaria));
        return dq;
    }
}