const mysql = require('mysql2/promise');
const dotenv = require('dotenv');
dotenv.config();

const pool = mysql.createPool({
    host: process.env.DATABASE_HOST,
    user: process.env.DATABASE_USER,
    password: process.env.DATABASE_PASSWORD,
    database: process.env.DATABASE_NAME,
    waitForConnections: true,
    connectionLimit: 10,
    port: 3306,
});

const getConnection = async () => {
    try {
        const connection = await pool.getConnection();
        return connection;
    } catch (error) {
        console.error(`connection error : ${error.message}`);
        return null;
    }
};

// 트랜잭션
const transaction = async (logic, req) => {
    const connection = await getConnection();
    if (!connection) {
        throw new Error('Unable to establish a database connection');
    }
    try {
        await connection.beginTransaction();
        const result = await logic(connection, req);
        await connection.commit();
        return result;
    } catch (err) {
        console.log("rollback connection");
        await connection.rollback();
        console.error("db error : ", err);
        throw err;
    } finally {
        console.log("release connection");
        connection.release();
    }
};

// 일반 연결
const query = async (queryString, params) => {
    try {
        const [results] = await pool.execute(queryString, params);
        return results;
    } catch (error) {
        console.error('Query error:', error);
        throw error;
    }
};

module.exports = {
    pool,
    transaction,
    query
};