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
            conn.setAutoCommit(false);
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
                if (rowsAffected == 0) {
                    throw new SQLException("Não foi possível vincular o quarto à diária");
                }
            }

            String ocuparSql = "UPDATE quarto SET status=2 WHERE idQuarto=? AND status=1";
            try (PreparedStatement ocupar = conn.prepareStatement(ocuparSql)) {
                ocupar.setInt(1, idQuarto);
                if (ocupar.executeUpdate() != 1) {
                    throw new SQLException("O quarto não está disponível para ocupação");
                }
            }

            conn.commit();
            sucesso = true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackError) {
                    Logger.getLogger(DiariaQuartoDAO.class.getName())
                            .log(Level.SEVERE, "Falha ao desfazer o vínculo do quarto", rollbackError);
                }
            }
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
            conn.setAutoCommit(false);
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setInt(1, idDiaria);
                pstm.setInt(2, idQuarto);
                int rowsAffected = pstm.executeUpdate();
                if (rowsAffected > 0) {
                    String liberarSql = "UPDATE quarto q SET q.status=1 "
                            + "WHERE q.idQuarto=? AND q.status=2 "
                            + "AND NOT EXISTS (SELECT 1 FROM diaria_quarto dq "
                            + "JOIN diaria d ON d.idDiaria=dq.diaria_idDiaria "
                            + "WHERE dq.quarto_idQuarto=q.idQuarto AND d.statusHospedagem=1)";
                    try (PreparedStatement liberar = conn.prepareStatement(liberarSql)) {
                        liberar.setInt(1, idQuarto);
                        liberar.executeUpdate();
                    }
                }
                conn.commit();
                sucesso = rowsAffected > 0;
            }
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackError) {
                    Logger.getLogger(DiariaQuartoDAO.class.getName())
                            .log(Level.SEVERE, "Falha ao desfazer a desvinculação do quarto", rollbackError);
                }
            }
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

    public ArrayList<DiariaQuarto> hospedagensAtivasPorNumeroQuarto(int numero) throws SQLException {
        ArrayList<DiariaQuarto> lista = new ArrayList<>();
        String sql = "SELECT dq.diaria_idDiaria, dq.quarto_idQuarto "
                   + "FROM diaria_quarto dq "
                   + "JOIN diaria d ON d.idDiaria = dq.diaria_idDiaria "
                   + "JOIN quarto q ON q.idQuarto = dq.quarto_idQuarto "
                   + "WHERE q.numero=? AND d.statusHospedagem=1";
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setInt(1, numero);
                try (ResultSet rs = pstm.executeQuery()) {
                    while (rs.next()) {
                        Diaria diaria = new Diaria();
                        diaria.setIdDiaria(rs.getInt("diaria_idDiaria"));
                        Quarto quarto = new Quarto();
                        quarto.setIdQuarto(rs.getInt("quarto_idQuarto"));

                        DiariaQuarto diariaQuarto = new DiariaQuarto();
                        diariaQuarto.setDiaria(diaria);
                        diariaQuarto.setQuarto(quarto);
                        lista.add(diariaQuarto);
                    }
                }
            }
        } finally {
            this.desconectar();
        }
        return lista;
    }

    public ArrayList<Quarto> quartosOcupados() throws SQLException {
        ArrayList<Quarto> lista = new ArrayList<>();
        String sql = "SELECT DISTINCT q.idQuarto, q.numero "
                   + "FROM quarto q "
                   + "JOIN diaria_quarto dq ON dq.quarto_idQuarto = q.idQuarto "
                   + "JOIN diaria d ON d.idDiaria = dq.diaria_idDiaria "
                   + "WHERE d.statusHospedagem=1 "
                   + "ORDER BY q.numero";
        try {
            this.conectar();
            try (PreparedStatement pstm = conn.prepareStatement(sql);
                 ResultSet rs = pstm.executeQuery()) {
                while (rs.next()) {
                    Quarto quarto = new Quarto();
                    quarto.setIdQuarto(rs.getInt("idQuarto"));
                    quarto.setNumero(rs.getInt("numero"));
                    lista.add(quarto);
                }
            }
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