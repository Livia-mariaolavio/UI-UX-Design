package com.banco.database;

import org.neo4j.driver.AuthTokens;
import org.neo4j.driver.Driver;
import org.neo4j.driver.GraphDatabase;
import org.neo4j.driver.Session;

public class ConexaoNeo4j {

    private static final String URI = "bolt://localhost:7687";
    private static final String USUARIO = "neo4j";
    private static final String SENHA = "JAMESDB0";

    private static final Driver driver = GraphDatabase.driver(URI, AuthTokens.basic(USUARIO, SENHA));

    public static Driver getDriver() {
        return driver;
    }

    public static Session getSession() {
        return driver.session();
    }
}

