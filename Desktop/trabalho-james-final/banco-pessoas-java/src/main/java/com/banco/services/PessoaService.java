package com.banco.services;

import com.banco.model.Pessoa;
import com.banco.repository.PessoaMongoLogger;
import com.banco.repository.PessoaPostgresRepository;
import com.banco.repository.PessoaRedisCache;

public class PessoaService {

    private final PessoaPostgresRepository postgres = new PessoaPostgresRepository(); // Adicionado 'final'
    private final PessoaRedisCache redis = new PessoaRedisCache(); // Adicionado 'final'
    private final PessoaMongoLogger mongo = new PessoaMongoLogger(); // Adicionado 'final'

    public void salvarPessoa(Pessoa pessoa) {
        postgres.salvarOuAtualizar(pessoa);
        redis.salvar(pessoa);
        mongo.log("UPSERT", pessoa); // novo ou atualizado
    }

    public Pessoa buscarPessoa(Long id) {
        Pessoa pessoa = redis.buscar(id);
        if (pessoa != null) {
            System.out.println("Pessoa encontrada no Redis");
            return pessoa;
        }

        pessoa = postgres.buscarPorId(id);
        if (pessoa != null) {
            System.out.println("Pessoa encontrada no PostgreSQL, salvando no Redis...");
            redis.salvar(pessoa);
        }

        return pessoa;
    }

    public void deletarPessoa(Long id) {
        Pessoa pessoa = postgres.buscarPorId(id); // Busca no Postgres primeiro para logar/confirmar existência
        if (pessoa != null) {
            postgres.deletar(id); // Deleta do PostgreSQL
            redis.deletar(id);   // Deleta do Redis para manter a consistência do cache
            mongo.log("DELETE", pessoa); // Loga a exclusão
            System.out.println("Pessoa com ID " + id + " deletada com sucesso.");
        } else {
            System.out.println("Pessoa com ID " + id + " não encontrada para exclusão.");
        }
    }
}
