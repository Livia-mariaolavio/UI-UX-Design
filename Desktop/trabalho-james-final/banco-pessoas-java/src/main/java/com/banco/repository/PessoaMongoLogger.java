package com.banco.repository;

import java.time.Instant;

import org.bson.Document;

import com.banco.database.ConexaoMongo;
import com.banco.model.Pessoa;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;

public class PessoaMongoLogger {

    public void log(String acao, Pessoa pessoa) {
        MongoDatabase db = ConexaoMongo.getDatabase();
        MongoCollection<Document> logs = db.getCollection("logs_pessoa");

        Document doc = new Document()
            .append("acao", acao)
            .append("timestamp", Instant.now().toString())
            .append("pessoa", new Document()
                .append("id", pessoa.getId())
                .append("nome", pessoa.getNome())
                .append("email", pessoa.getEmail())
                .append("cpf", pessoa.getCpf())
            );

        logs.insertOne(doc);
        System.out.println("Log inserido no MongoDB: " + acao);
    }
}
