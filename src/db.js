const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');

const pool = new Pool({
  user: 'postgres',
  host: 'db',
  database: 'cyberbase',
  password: 'password',
  port: 5432,
});

const executeSQLFile = async (filePath) => {
  const fullPath = path.resolve(__dirname, '..', filePath);
  const sql = fs.readFileSync(fullPath, 'utf8');
  try {
    await pool.query(sql);
    console.log(`Arquivo ${filePath} executado com sucesso.`);
  } catch (error) {
    console.error(`Erro ao executar ${filePath}:`, error);
  }
};

module.exports = { pool, executeSQLFile };
