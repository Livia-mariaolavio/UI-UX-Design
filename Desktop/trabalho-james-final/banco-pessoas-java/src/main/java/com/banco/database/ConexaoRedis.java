package com.banco.database;

import redis.clients.jedis.Jedis;

public class ConexaoRedis {
    public static Jedis getConnection() {
        return new Jedis("localhost", 6379);
    }
}

