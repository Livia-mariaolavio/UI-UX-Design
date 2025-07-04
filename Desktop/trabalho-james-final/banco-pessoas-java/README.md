# Projeto Banco de Pessoas com Múltiplos Bancos de Dados

Este projeto é um sistema de gerenciamento de pessoas que utiliza múltiplos bancos de dados para diferentes propósitos: PostgreSQL para dados relacionais, Redis para cache e MongoDB/Neo4j para logs e grafos de relacionamento.

## Tecnologias Utilizadas

* **Java 17+**
* **Maven** (para gerenciamento de dependências)
* **PostgreSQL** (Banco de dados relacional para dados principais)
* **Redis** (Cache para acesso rápido a dados de pessoas)
* **MongoDB** (Para logging de operações)
* **Neo4j** (Banco de dados de grafo para relacionamentos entre pessoas)
* **Jedis** (Cliente Java para Redis)
* **Neo4j Java Driver** (Cliente Java para Neo4j)

## Funcionalidades

* Cadastro e atualização de pessoas (ID, Nome, Email, CPF, Data de Nascimento)
* Busca de pessoas por ID
* Exclusão de pessoas
* Registro de diferentes tipos de relacionamentos entre pessoas no Neo4j (Contato Profissional, Membro da Família, Companheiro de Projeto)
* Caching de dados de pessoas no Redis para buscas rápidas
* Logging de operações de CRUD no MongoDB

## Como Configurar e Rodar o Projeto

### Pré-requisitos

Certifique-se de ter os seguintes softwares instalados e configurados:

* JDK (Java Development Kit) 17 ou superior
* Maven
* Docker (recomendado para rodar os bancos de dados facilmente) ou instalações locais de:
    * PostgreSQL
    * Redis
    * MongoDB
    * Neo4j Desktop (para Neo4j)

### Configuração dos Bancos de Dados

Você precisará configurar as conexões para cada banco de dados nas suas classes `ConexaoPostgres.java`, `ConexaoRedis.java`, `ConexaoMongo.java` e `ConexaoNeo44j.java`. Certifique-se de que as credenciais e URLs estão corretas.

#### Exemplo de Configuração (se usando Docker)

Para rodar os bancos de dados com Docker, você pode usar um `docker-compose.yml` (exemplo simplificado):

```yaml
version: '3.8'
services:
  postgres:
    image: postgres:13
    environment:
      POSTGRES_DB: banco_pessoas
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:latest
    ports:
      - "6379:6379"

  mongodb:
    image: mongo:latest
    ports:
      - "27017:27017"
    volumes:
      - mongo_data:/data/db

  neo4j:
    image: neo4j:latest
    environment:
      NEO4J_AUTH: neo4j/password
    ports:
      - "7474:7474" # Browser
      - "7687:7687" # Bolt
    volumes:
      - neo4j_data:/data

volumes:
  postgres_data:
  mongo_data:
  neo4j_data: