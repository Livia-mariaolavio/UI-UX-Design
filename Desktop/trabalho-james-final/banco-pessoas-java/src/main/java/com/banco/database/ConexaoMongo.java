package com.banco.database;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;

public class ConexaoMongo {

    private static final String URI = "mongodb://localhost:27017";
    private static final MongoClient client = MongoClients.create(URI);

    // Retorna a instância do banco de dados
    public static MongoDatabase getDatabase() {
        return client.getDatabase("logs_pessoa"); // Ajuste o nome aqui se precisar
    }

    // Encerra a conexão com o MongoDB
    public static void close() {
        client.close();
    }
}

