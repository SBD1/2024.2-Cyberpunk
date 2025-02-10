const express = require('express');
const { Pool } = require('pg');
const path = require('path');
const fs = require('fs');
const { iniciarMissao } = require('./missaoPuzzle'); // Importando a função de missão
const prompt = require('prompt-sync')();

const app = express();
const initialPort = 3000;

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
      SELECT c.*, s.nomeSala
      FROM CyberLutador c
      LEFT JOIN Sala s ON c.fk_sala_atual = s.idSala
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

    const queryInsercao = `
      INSERT INTO CyberLutador 
        (nomeCyberLutador, inteligencia, resistencia, furtividade, percepcao, vida, velocidade, forca, fk_sala_atual)
      VALUES 
        ($1, $2, $3, $4, $5, $6, $7, $8, $9)
      RETURNING idCyberLutador;
    `;
    const valuesInsercao = [
      nomeCyberLutador, inteligencia, resistencia, furtividade, percepcao, vida, velocidade, forca, fkSalaAtual
    ];

    const res = await pool.query(queryInsercao, valuesInsercao);
    const idCyberLutador = res.rows[0].idcyberlutador;

    console.log('CyberLutador criado:', res.rows[0]);

    // Lógica para Facção
    console.log(`Escolha à qual facção o CyberLutador está representando: 
      1 - Facção NetRunners, o Cyberlutador terá +2 Inteligência e Percepção
      2 - Facção CodeKeepers, o Cyberlutador terá +2 Resistência e Velocidade`);

    let faccao;
    let query;
    let values;

    do {
      faccao = prompt("Digite o número da facção: ");
      switch (faccao) {
        case "1":
          console.log("Facção NetRunners selecionada!");

          query = `INSERT INTO Faccao (fk_cyberlutador, nomeFaccao, ideologia) 
                   VALUES ($1, $2, $3);`;
          values = [idCyberLutador, "NetRunners", "Tecnologia e inovação"];
          await pool.query(query, values);

          query = `UPDATE CyberLutador 
                   SET inteligencia = inteligencia + 2,
                       percepcao = percepcao + 2 
                   WHERE idcyberlutador = $1;`;
          values = [idCyberLutador];
          await pool.query(query, values);
          break;

        case "2":
          console.log("Facção CodeKeepers selecionada!");

          query = `INSERT INTO Faccao (fk_cyberlutador, nomeFaccao, ideologia) 
                   VALUES ($1, $2, $3);`;
          values = [idCyberLutador, "CodeKeepers", "Segurança e preservação"];
          await pool.query(query, values);

          query = `UPDATE CyberLutador 
                   SET velocidade = velocidade + 2,
                       resistencia = resistencia + 2
                   WHERE idcyberlutador = $1;`;
          values = [idCyberLutador];
          await pool.query(query, values);
          break;

        default:
          console.log("Opção inválida, por favor digite 1 ou 2.");
      }
    } while (faccao !== "1" && faccao !== "2");

    return res.rows[0];
  } catch (error) {
    console.error('Erro ao adicionar CyberLutador:', error);
    throw error;
  }
}

async function getMissoes() {
  try {
    const res = await pool.query('SELECT * FROM Missao ORDER BY idMissao');
    return res.rows;
  } catch (error) {
    console.error('Erro ao consultar as missões:', error);
    throw error;
  }
}

async function concluirMissao(idMissao) {
  try {
    const query = 'UPDATE Missao SET concluida = TRUE WHERE idMissao = $1 RETURNING *';
    const res = await pool.query(query, [idMissao]);
    return res.rows[0];
  } catch (error) {
    console.error('Erro ao concluir missão:', error);
    throw error;
  }
}

async function init() {
  try {
    await waitForDatabase();
    // console.log('Resetando banco de dados...');
    // await executeSQLFile(path.join(__dirname, '../ddl/reset_db.sql'));

    console.log('Criando tabelas...');
    await executeSQLFile(path.join(__dirname, '../ddl/create_tables.sql'));

    console.log('Inserindo salas...');
    await executeSQLFile(path.join(__dirname, '../dml/insert_salas.sql'));

    console.log('Inserindo Mercado...');
    await executeSQLFile(path.join(__dirname, '../dml/insert_mercado.sql'));

    console.log('Inserindo NPCs...');
    await executeSQLFile(path.join(__dirname, '../dml/insert_npc.sql'));

    console.log('Inserindo Itens...');
    await executeSQLFile(path.join(__dirname, '../dml/insert_itens.sql'));

    console.log('Inserindo Triggers e Procedures...');
    await executeSQLFile(path.join(__dirname, '../triggers-procedures/triggers-procedures.sql'));

    console.log('Dados inseridos com sucesso.');
  } catch (err) {
    console.error('Erro na inicialização:', err);
    process.exit(1);
  }
}
async function startServer(port) {
  return new Promise((resolve, reject) => {
    app.listen(port, () => {
      console.log(`Servidor rodando na porta ${port}`);
      resolve();
    }).on('error', (err) => {
      if (err.code === 'EADDRINUSE') {
        console.log(`Porta ${port} em uso, tentando a próxima...`);
        startServer(port + 1).then(resolve).catch(reject);
      } else {
        reject(err);
      }
    });
  });
}

init().then(() => {
  startServer(initialPort).catch((err) => {
    console.error('Erro ao iniciar o servidor:', err);
    process.exit(1);
  });
});

module.exports = {
  init,
  getSalas, adicionarSala,
  getCyberLutadores, adicionarCyberLutador
};