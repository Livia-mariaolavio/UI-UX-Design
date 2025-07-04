package com.banco.create_tabela;


import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import com.banco.database.ConexaoPostgres;

public class CriarTabelasPostgres {

    public static void criarTabelaPessoa() {
        String sql = """
            CREATE TABLE IF NOT EXISTS pessoa (
                id BIGINT PRIMARY KEY,
                nome VARCHAR(100),
                idade INTEGER,
                email VARCHAR(100),
                cpf VARCHAR(20)
            );
        """;

        try (Connection conn = ConexaoPostgres.getConnection();
             Statement stmt = conn.createStatement()) {

            stmt.executeUpdate(sql);
            System.out.println("Tabela 'pessoa' criada (ou já existia).");

        } catch (SQLException e) {
            System.err.println("Erro ao criar tabela 'pessoa': " + e.getMessage());
        }
    }
}
