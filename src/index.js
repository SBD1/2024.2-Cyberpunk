const express = require('express');
const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');

const app = express();
const port = 3000;

const pool = new Pool({
  user: 'postgres',
  host: 'db',
  database: 'cyberbase',
  password: 'password',
  port: 5432,
});

async function executeSQLFile(filePath) {
  const sql = fs.readFileSync(filePath, 'utf8');
  try {
    await pool.query(sql);
    console.log(`Arquivo ${filePath} executado com sucesso.`);
  } catch (error) {
    console.error(`Erro ao executar ${filePath}:`, error);
    throw error;
  }
}

async function init() {
  console.log('Criando tabelas...');
  await executeSQLFile(path.join(__dirname, '../ddl/create_tables.sql'));

  console.log('Inserindo usuário de exemplo...');
  try {
    const result = await pool.query(
      'INSERT INTO users (name, email) VALUES ($1, $2) RETURNING *',
      ['John Doe', 'john.doe@example.com']
    );
    console.log('Usuário inserido:', result.rows[0]);
  } catch (error) {
    console.error('Erro durante a inicialização:', error);
  }
}

init()
  .then(() => {
    app.listen(port, () => {
      console.log(`Servidor rodando na porta ${port}`);
    });
  })
  .catch((err) => {
    console.error('Erro na inicialização:', err);
  });
