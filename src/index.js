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
      console.error(`Erro de conexão: ${err.message}`);
      console.log('Banco de dados não está pronto, aguardando...');
      retries--;
      await new Promise((resolve) => setTimeout(resolve, 3000));
    }
  }
  throw new Error('O banco de dados não inicializou dentro do tempo esperado.');
}

async function getSalas() {
  try {
    const res = await pool.query(`
      SELECT *
      FROM Sala s
      LEFT JOIN Regiao r ON s.fk_regiao = r.idRegiao
    `);
    return res.rows;
  } catch (error) {
    console.error('Erro ao consultar as salas:', error);
    throw error;
  }
}

async function adicionarSala(nomeSala, fkRegiao, norte = null, sul = null, leste = null, oeste = null) {
  try {
    const query = `
      INSERT INTO Sala (nomeSala, fk_regiao, norte, sul, leste, oeste)
      VALUES ($1, $2, $3, $4, $5, $6)
      RETURNING *;
    `;
    const values = [nomeSala, fkRegiao, norte, sul, leste, oeste];
    const res = await pool.query(query, values);
    console.log('Sala adicionada:', res.rows[0]);
    return res.rows[0];
  } catch (error) {
    console.error('Erro ao adicionar sala:', error);
    throw error;
  }
}

async function getCyberLutadores() {
  try {
    const res = await pool.query(`
      SELECT idCyberLutador, nomeCyberLutador
      FROM CyberLutador c
    `);
    return res.rows;
  } catch (error) {
    console.error('Erro ao consultar os cyberlutadores:', error);
    throw error;
  }
}

async function adicionarCyberLutador(nomeCyberLutador, fkSalaAtual) {
  try {
    const atributosAleatorios = Array.from({ length: 7 }, () => Math.floor(Math.random() * 5)); // Valores entre 0 e 4
    const [inteligencia, resistencia, furtividade, percepcao, vida, velocidade, forca] = atributosAleatorios;

    const query = `
      INSERT INTO CyberLutador 
        (nomeCyberLutador, inteligencia, resistencia, furtividade, percepcao, vida, velocidade, forca, fk_sala_atual)
      VALUES 
        ($1, $2, $3, $4, $5, $6, $7, $8, $9)
      RETURNING *;
    `;
    const values = [
      nomeCyberLutador, inteligencia, resistencia, furtividade, percepcao, vida, velocidade, forca, fkSalaAtual
    ];

    const res = await pool.query(query, values);
    console.log('CyberLutador criado:', res.rows[0]);
    return res.rows[0];
  } catch (error) {
    console.error('Erro ao adicionar CyberLutador:', error);
    throw error;
  }
}

async function init() {
  try {
    await waitForDatabase();
    console.log('Resetando banco de dados...');
    await executeSQLFile(path.join(__dirname, '../ddl/reset_db.sql'));

    console.log('Criando tabelas...');
    await executeSQLFile(path.join(__dirname, '../ddl/create_tables.sql'));

    console.log('Inserindo salas...');
    await executeSQLFile(path.join(__dirname, '../dml/insert_salas.sql'));

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

module.exports = {
  init,
  getSalas, adicionarSala,
  getCyberLutadores, adicionarCyberLutador
};