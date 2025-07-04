package com.banco.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexaoPostgres {
    private static final String URL = "jdbc:postgresql://localhost:5432/banco_pessoas";
    private static final String USUARIO = "postgres";
    private static final String SENHA = "elefante";

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USUARIO, SENHA);
    }
}


