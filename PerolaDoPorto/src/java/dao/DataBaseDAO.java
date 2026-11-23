/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author adm_pfelacio
 */
public class DataBaseDAO {
    
    private static final String URL = System.getProperty("perola.db.url",
            System.getenv().getOrDefault("PEROLA_DB_URL",
                    "jdbc:mysql://localhost:3306/perolatcc_novo?useSSL=false&useUnicode=true&characterEncoding=UTF-8"));
    private static final String USER = System.getProperty("perola.db.user",
            System.getenv().getOrDefault("PEROLA_DB_USER", "root"));
    private static final String PASSWORD = System.getProperty("perola.db.password",
            System.getenv().getOrDefault("PEROLA_DB_PASSWORD", ""));
    
    public Connection conn;

    //metodo para carregar o driver do mysql
    public DataBaseDAO() throws ClassNotFoundException {
        Class.forName("com.mysql.jdbc.Driver");
    }
    
    //metodo para conectar ao banco de dados
    public void conectar()throws SQLException{
        if(conn==null||conn.isClosed()){
            conn=DriverManager.getConnection(URL, USER, PASSWORD);
        }
    }
    
    //metodo para desconectar do banco de dados
    public void desconectar(){
        if(conn!=null){
            try{
                conn.close();
            }catch(SQLException e){
                System.out.println("Erro ao fechar a conexão"+e);
            }
        }
    }
    //metodo para obter a conexao(caso precise fora da classe)
    public Connection getConnection(){
        return conn;
    }
    
    
    
}
