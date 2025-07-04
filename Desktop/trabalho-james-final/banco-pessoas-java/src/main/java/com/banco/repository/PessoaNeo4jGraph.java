package com.banco.repository;

import org.neo4j.driver.Driver;
import org.neo4j.driver.Session;

import com.banco.database.ConexaoNeo4j;

public class PessoaNeo4jGraph {

    private final Driver driver = ConexaoNeo4j.getDriver();

    public void criarPessoaSeNaoExistir(Long id, String nome) {
        try (Session session = driver.session()) {
            session.run("""
                MERGE (p:Pessoa {id: $id})
                SET p.nome = $nome
            """, 
            org.neo4j.driver.Values.parameters("id", id, "nome", nome));
        }
    }

    public void criarAmizade(Long id1, String nome1, Long id2, String nome2) {
        try (Session session = driver.session()) {
            session.run("""
                MERGE (a:Pessoa {id: $id1})
                SET a.nome = $nome1
                MERGE (b:Pessoa {id: $id2})
                SET b.nome = $nome2
                MERGE (a)-[:CONTATO-PROFISSIONAL]->(b)
            """, 
            org.neo4j.driver.Values.parameters(
                "id1", id1, "nome1", nome1,
                "id2", id2, "nome2", nome2
            ));
            System.out.println("contato registrada no Neo4j.");
        }
    }
        public void criarParentesco(Long id1, String nome1, Long id2, String nome2) {
        try (Session session = driver.session()) {
            session.run("""
                MERGE (a:Pessoa {id: $id1})
                SET a.nome = $nome1
                MERGE (b:Pessoa {id: $id2})
                SET b.nome = $nome2
                MERGE (a)-[:PARENTE_DE]->(b)
            """, 
            org.neo4j.driver.Values.parameters(
                "id1", id1, "nome1", nome1,
                "id2", id2, "nome2", nome2
            ));
            System.out.println("Parente registrada no Neo4j.");
        }
    }
        public void criarColega(Long id1, String nome1, Long id2, String nome2) {
        try (Session session = driver.session()) {
            session.run("""
                MERGE (a:Pessoa {id: $id1})
                SET a.nome = $nome1
                MERGE (b:Pessoa {id: $id2})
                SET b.nome = $nome2
                MERGE (a)-[:COMPANHEIRO]->(b)
            """, 
            org.neo4j.driver.Values.parameters(
                "id1", id1, "nome1", nome1,
                "id2", id2, "nome2", nome2
            ));
            System.out.println("companheiro registrado no Neo4j.");
        }
    }
}

