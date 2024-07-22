const db = require('../../config/dbConfig');

const getMemberByEmail = async (email) => {
    const rows = await db.query('SELECT * FROM Member WHERE email = ?', [email]);
    return rows;
};

const getMemberIdByEmail = async (email) => {
    const rows = await db.query('SELECT memberId FROM Member WHERE email = ?', [email]);
    return rows;
};

module.exports ={
    getMemberByEmail
};