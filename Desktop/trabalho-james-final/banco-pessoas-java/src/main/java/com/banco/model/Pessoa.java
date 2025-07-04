package com.banco.model;

import java.time.LocalDate; // Importar LocalDate

public class Pessoa {
    private Long id;
    private String nome;
    private String email;
    private String cpf;
    private LocalDate dataNascimento; // Alterado de String para LocalDate

    // Construtor vazio
    public Pessoa() {}

    // Construtor completo
    // Alterado o tipo do parâmetro dataNascimento para LocalDate
    public Pessoa(Long id, String nome, String email, String cpf, LocalDate dataNascimento) {
        this.id = id;
        this.nome = nome;
        this.email = email;
        this.cpf = cpf;
        this.dataNascimento = dataNascimento;
    }

    // Getters e Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCpf() {
        return cpf;
    }

    public void setCpf(String cpf) {
        this.cpf = cpf;
    }

    // Alterado o tipo do parâmetro para LocalDate
    public void setDataNascimento(LocalDate dataNascimento) {
        this.dataNascimento = dataNascimento;
    }

    // Alterado o tipo de retorno para LocalDate
    public LocalDate getDataNascimento() {
        return dataNascimento;
    }

    @Override
    public String toString() {
        return "Pessoa{" +
               "id=" + id +
               ", nome='" + nome + '\'' +
               ", email='" + email + '\'' +
               ", cpf='" + cpf + '\'' +
               ", dataNascimento=" + dataNascimento + // LocalDate já tem um toString adequado
               '}';
    }
}
