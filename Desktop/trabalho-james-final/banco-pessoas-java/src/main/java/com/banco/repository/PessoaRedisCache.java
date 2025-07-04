package com.banco.repository;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;

import com.banco.database.ConexaoRedis;
import com.banco.model.Pessoa; // Import necessário para LocalDate

import redis.clients.jedis.Jedis; // Import necessário para tratar a data

public class PessoaRedisCache {

    // Salva a pessoa por ID e também cria um índice para busca por CPF
    public void salvar(Pessoa pessoa) {
        try (Jedis jedis = ConexaoRedis.getConnection()) {
            String idKey = "pessoa:" + pessoa.getId();
            String cpfKey = "cpf:" + pessoa.getCpf();

            // Certifica-se de que getDataNascimento() não é nulo antes de chamar toString()
            // E converte LocalDate para String para String.join()
            String dataNascimentoStr = (pessoa.getDataNascimento() != null) ? pessoa.getDataNascimento().toString() : "";

            String valor = String.join(";",
                pessoa.getNome(),
                pessoa.getEmail(),
                pessoa.getCpf(),
                dataNascimentoStr // Use a string da data de nascimento
            );

            // Salva os dados da pessoa
            jedis.set(idKey, valor);

            // Mapeia CPF para ID
            jedis.set(cpfKey, pessoa.getId().toString());

            System.out.println("[Redis] Pessoa " + pessoa.getId() + " salva no cache.");

        } catch (Exception e) {
            System.err.println("Erro ao salvar no Redis: " + e.getMessage());
            e.printStackTrace(); // Imprime o stack trace para mais detalhes do erro
        }
    }

    // Busca uma pessoa pelo ID
    public Pessoa buscar(Long id) {
        try (Jedis jedis = ConexaoRedis.getConnection()) {
            String chave = "pessoa:" + id;
            String valor = jedis.get(chave);

            if (valor != null) {
                String[] partes = valor.split(";");
                // Garantir que todas as partes necessárias existam
                if (partes.length >= 4) { // Nome;Email;CPF;DataNascimento
                    String nome = partes[0];
                    String email = partes[1];
                    String cpf = partes[2];
                    String nascimentoStr = partes[3];
                    LocalDate dataNascimento = null;
                    try {
                        if (!nascimentoStr.isEmpty()) {
                            dataNascimento = LocalDate.parse(nascimentoStr);
                        }
                    } catch (DateTimeParseException e) {
                        System.err.println("Erro ao parsear data de nascimento do Redis para Pessoa ID " + id + ": " + e.getMessage());
                        // Opcional: tratar como erro ou continuar com dataNascimento nula
                    }
                    System.out.println("[Redis] Pessoa " + id + " encontrada no cache.");
                    return new Pessoa(id, nome, email, cpf, dataNascimento); // Usa LocalDate
                }
            }
        } catch (Exception e) {
            System.err.println("Erro ao buscar no Redis: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Busca uma pessoa pelo CPF
    public Pessoa buscarPorCpf(String cpf) {
        try (Jedis jedis = ConexaoRedis.getConnection()) {
            String cpfKey = "cpf:" + cpf;
            String idString = jedis.get(cpfKey);

            if (idString != null) {
                Long id = Long.parseLong(idString);
                return buscar(id); // Reusa o método buscar(id)
            } else {
                System.out.println("[Redis] CPF " + cpf + " não encontrado no cache.");
            }
        } catch (Exception e) {
            System.err.println("Erro ao buscar por CPF no Redis: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Método DELETAR
    public void deletar(Long id) {
        try (Jedis jedis = ConexaoRedis.getConnection()) {
            String idKey = "pessoa:" + id;
            
            // 1. Tentar obter o CPF da pessoa para remover o índice também
            String pessoaValor = jedis.get(idKey);
            String cpf = null;
            if (pessoaValor != null) {
                String[] partes = pessoaValor.split(";");
                // O CPF está na terceira posição (índice 2) se o formato for Nome;Email;CPF;DataNascimento
                if (partes.length >= 3) { 
                    cpf = partes[2]; 
                }
            }

            // 2. Remover a chave principal da pessoa pelo ID
            Long deletedCount = jedis.del(idKey);

            // 3. Se um CPF foi encontrado, remover também a chave do índice de CPF
            if (cpf != null) {
                String cpfKey = "cpf:" + cpf;
                jedis.del(cpfKey);
            }

            if (deletedCount > 0) {
                System.out.println("[Redis] Pessoa " + id + " e seu índice de CPF deletados do cache.");
            } else {
                System.out.println("[Redis] Pessoa " + id + " não encontrada no cache para exclusão.");
            }

        } catch (Exception e) {
            System.err.println("Erro ao deletar do Redis: " + e.getMessage());
            e.printStackTrace(); // Para ver o stack trace completo do erro
        }
    }
}
