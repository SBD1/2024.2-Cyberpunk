const express = require('express');
const { Pool } = require('pg');
const path = require('path');
const fs = require('fs');

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
async function waitForDatabase() {
  let retries = 10;
  while (retries > 0) {
    try {
      console.log('Verificando se o banco de dados está pronto...');
      await pool.query('SELECT 1'); // Testa a conexão
      console.log('Banco de dados está pronto!');
      return;
    } catch (err) {
      console.log('Banco de dados não está pronto, aguardando...');
      retries--;
      await new Promise((resolve) => setTimeout(resolve, 3000));
    }
  }
  throw new Error('O banco de dados não inicializou dentro do tempo esperado.');
}

async function init() {
  try {
    await waitForDatabase();
    console.log('Resetando banco de dados...');
    await executeSQLFile(path.join(__dirname, '../ddl/reset_db.sql'));

    console.log('Criando tabelas...');
    await executeSQLFile(path.join(__dirname, '../ddl/create_tables.sql'));

    // deixar comentado por enquanto
    // console.log('Inserindo dados...');
    // await executeSQLFile(path.join(__dirname, '../dml/insert_data.sql'));

    console.log('Dados inseridos com sucesso.');
  } catch (err) {
    console.error('Erro na inicialização:', err);
    process.exit(1);
  }
}

init().then(() => {
  app.listen(port, () => {
    console.log(`Servidor rodando na porta ${port}`);
  });
});
