package com.banco.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

import com.banco.database.ConexaoPostgres; // Importar LocalDate
import com.banco.model.Pessoa; // Importar para tratamento de erro de data

public class PessoaPostgresRepository {

    public void salvarOuAtualizar(Pessoa pessoa) {
        String sql = "INSERT INTO pessoa (id, nome, email, cpf, data_nascimento) VALUES (?, ?, ?, ?, ?) " +
                     "ON CONFLICT (id) DO UPDATE SET nome = EXCLUDED.nome, email = EXCLUDED.email, " +
                     "cpf = EXCLUDED.cpf, data_nascimento = EXCLUDED.data_nascimento";

        try (Connection conn = ConexaoPostgres.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, pessoa.getId());
            stmt.setString(2, pessoa.getNome());
            stmt.setString(3, pessoa.getEmail());
            stmt.setString(4, pessoa.getCpf());
            
            // Converte LocalDate para java.sql.Date para salvar no banco de dados
            if (pessoa.getDataNascimento() != null) {
                stmt.setDate(5, java.sql.Date.valueOf(pessoa.getDataNascimento()));
            } else {
                stmt.setNull(5, java.sql.Types.DATE);
            }

            stmt.executeUpdate();
            System.out.println("Pessoa salva/atualizada no PostgreSQL com sucesso!");

        } catch (SQLException e) {
            if (e.getMessage() != null && e.getMessage().contains("violates unique constraint")) {
                System.err.println("Erro: Já existe uma pessoa com o ID " + pessoa.getId());
            } else {
                System.err.println("Erro ao salvar/atualizar no PostgreSQL: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }

    public Pessoa buscarPorId(Long id) {
        String sql = "SELECT id, nome, email, cpf, data_nascimento FROM pessoa WHERE id = ?";
        try (Connection conn = ConexaoPostgres.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Pessoa pessoa = new Pessoa();
                    pessoa.setId(rs.getLong("id"));
                    pessoa.setNome(rs.getString("nome"));
                    pessoa.setEmail(rs.getString("email"));
                    pessoa.setCpf(rs.getString("cpf"));
                    
                    // Recupera a data como String e converte para LocalDate
                    String dataNascimentoStr = rs.getString("data_nascimento");
                    if (dataNascimentoStr != null) {
                        try {
                            pessoa.setDataNascimento(LocalDate.parse(dataNascimentoStr));
                        } catch (DateTimeParseException e) {
                            System.err.println("Erro ao parsear data de nascimento do PostgreSQL para Pessoa ID " + id + ": " + e.getMessage());
                            // Opcional: tratar como erro ou continuar com dataNascimento nula
                        }
                    }
                    System.out.println("Pessoa " + id + " encontrada no PostgreSQL.");
                    return pessoa;
                }
            }
        } catch (SQLException e) {
            System.err.println("Erro ao buscar no PostgreSQL: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public void deletar(Long id) {
        String sql = "DELETE FROM pessoa WHERE id = ?";
        try (Connection conn = ConexaoPostgres.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Pessoa " + id + " deletada do PostgreSQL com sucesso.");
            } else {
                System.out.println("Pessoa " + id + " não encontrada no PostgreSQL para exclusão.");
            }
        } catch (SQLException e) {
            System.err.println("Erro ao deletar do PostgreSQL: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public java.util.List<Pessoa> listarTodas() {
        java.util.List<Pessoa> pessoas = new java.util.ArrayList<>();
        String sql = "SELECT id, nome, email, cpf, data_nascimento FROM pessoa";
        try (Connection conn = ConexaoPostgres.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Pessoa pessoa = new Pessoa();
                pessoa.setId(rs.getLong("id"));
                pessoa.setNome(rs.getString("nome"));
                pessoa.setEmail(rs.getString("email"));
                pessoa.setCpf(rs.getString("cpf"));
                
                // Recupera a data como String e converte para LocalDate
                String dataNascimentoStr = rs.getString("data_nascimento");
                if (dataNascimentoStr != null) {
                    try {
                        pessoa.setDataNascimento(LocalDate.parse(dataNascimentoStr));
                    } catch (DateTimeParseException e) {
                        System.err.println("Erro ao parsear data de nascimento do PostgreSQL para Pessoa ID " + pessoa.getId() + ": " + e.getMessage());
                        // Opcional: tratar como erro ou continuar com dataNascimento nula
                    }
                }
                pessoas.add(pessoa);
            }
        } catch (SQLException e) {
            System.err.println("Erro ao listar todas as pessoas do PostgreSQL: " + e.getMessage());
            e.printStackTrace();
        }
        return pessoas;
    }
}
