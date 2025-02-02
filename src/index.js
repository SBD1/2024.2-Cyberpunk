const express = require('express');
const { Pool } = require('pg');
const path = require('path');
const fs = require('fs');
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
    console.log("getcyber", res.rows);
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
      RETURNING idCyberLutador;
    `;
    const values = [
      nomeCyberLutador, inteligencia, resistencia, furtividade, percepcao, vida, velocidade, forca, fkSalaAtual
    ];

    const res = await pool.query(query, values);
    console.log('CyberLutador criado:', res.rows[0]);

    // Lógica para Facção

    console.log(`Escolha à qual facção o CyberLutador está representando: 
      1 - Facção NetRunners, o Cyberlutador terá +2 Inteligência e Percepção
      2 - Facção CodeKeepers, o Cyberlutador terá +2 Resistência e Velocidade`);

      do {
        var faccao = prompt("Digite o número da facção: ");
        switch (faccao) {
          case "1":
            console.log("Facção NetRunners selecionada!");
            // Inserir a facção "NetRunners"
            let query = `INSERT INTO Faccao (fk_cyberlutador, nomeFaccao) 
                         VALUES ($1, $2);`;
            let values = [res.rows[0].idcyberlutador, "NetRunners"];
            await pool.query(query, values);
      
            // Atualizar atributos do CyberLutador
            query = `UPDATE CyberLutador 
                     SET inteligencia = inteligencia + 2,
                         percepcao = percepcao + 2 
                     WHERE idcyberlutador = $1;`;
            values = [res.rows[0].idcyberlutador];
            await pool.query(query, values);
            break;
      
          case "2":
            console.log("Facção CodeKeepers selecionada!");
            // Inserir a facção "CodeKeepers"
            query = `INSERT INTO Faccao (fk_cyberlutador, nomeFaccao) 
                     VALUES ($1, $2);`;
            values = [res.rows[0].idcyberlutador, "CodeKeepers"];
            await pool.query(query, values);
      
            // Atualizar atributos do CyberLutador
            query = `UPDATE CyberLutador 
                     SET velocidade = inteligencia + 2,
                         resistencia = resistencia + 2
                     WHERE idcyberlutador = $1;`;
            values = [res.rows[0].idcyberlutador];
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

async function init() {
  try {
    await waitForDatabase();
     console.log('Resetando banco de dados...');
     await executeSQLFile(path.join(__dirname, '../ddl/reset_db.sql'));
    
    console.log('Criando tabelas...');
    await executeSQLFile(path.join(__dirname, '../ddl/create_tables.sql'));

    console.log('Inserindo salas...');
    await executeSQLFile(path.join(__dirname, '../dml/insert_salas.sql'));

    console.log('Inserindo Triggers e Procedures...');
    await executeSQLFile(path.join(__dirname, '../ddl/triggers-procedures.sql'));

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
