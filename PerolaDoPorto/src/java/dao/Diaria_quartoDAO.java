package model;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Diaria_quartoDAO extends DataBaseDAO {

    public Diaria_quartoDAO() throws ClassNotFoundException {
    }

    public boolean vincular(int idDiaria, int idQuarto, double valorAtual) {
        boolean sucesso = false;
        String sql = "INSERT INTO diaria_quarto (diaria_idDiaria, quarto_idQuarto, valorAtual) VALUES(?,?,?)";
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setInt(1, idDiaria);
                pstm.setInt(2, idQuarto);
                pstm.setDouble(3, valorAtual);
                int rowsAffected = pstm.executeUpdate();
                if (rowsAffected > 0) {
                    sucesso = true;
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(Diaria_quartoDAO.class.getName()).log(Level.SEVERE, null, e);
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
            Logger.getLogger(Diaria_quartoDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return sucesso;
    }

    public ArrayList<Diaria_quarto> quartosVinculadosPorDiaria(int idDiaria) {
        ArrayList<Diaria_quarto> lista = new ArrayList<>();
        String sql = "SELECT dq.*, q.* FROM diaria_quarto as dq, quarto as q "
                   + " WHERE dq.quarto_idQuarto = q.idQuarto "
                   + " AND dq.diaria_idDiaria=?";
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setInt(1, idDiaria);
                try (ResultSet rs = pstm.executeQuery()) {
                    while (rs.next()) {
                        Diaria_quarto dq = new Diaria_quarto();
                        dq.setValorAtual(rs.getDouble("dq.valorAtual"));
                        
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
            Logger.getLogger(Diaria_quartoDAO.class.getName()).log(Level.SEVERE, null, e);
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
            Logger.getLogger(Diaria_quartoDAO.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            this.desconectar();
        }
        return lista;
    }
    public Diaria_quarto getCarregaQuartosPorDiaria(int idDiaria) {
        Diaria_quarto dq = new Diaria_quarto();
        dq.setQuartosVinculados(quartosVinculadosPorDiaria(idDiaria));
        dq.setQuartosNaoVinculados(quartosNaoVinculadosPorDiaria(idDiaria));
        return dq;
    }
}