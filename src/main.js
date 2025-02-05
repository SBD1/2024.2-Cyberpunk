const { Pool } = require('pg');
const prompt = require('prompt-sync')();
const { init, getSalas, getCyberLutadores, adicionarCyberLutador } = require('./index');
const { iniciarMissao, carregarProgressoMissao } = require('./missaoPuzzle');
const { abrirMercado } = require('./mercado');
const { interagirComNeon, interagirComShade, interagirComCipher } = require('./mentor');

const pool = new Pool({
  user: 'postgres',
  host: 'db',
  database: 'cyberbase',
  password: 'password',
  port: 5432,
});

let cyberlutadores = [];
let salas = {};
let salasArray = [];

async function carregarSalas() {
  salasArray = await getSalas();
  salas = {};
  salasArray.forEach(sala => {
    salas[sala.nomeSala] = sala.idSala;
  });
}

class CyberLutador {
  constructor(idcyberlutador, nomecyberLutador, nomeSala) {
    this.id = idcyberlutador;
    this.nome = nomecyberLutador;
    this.salaAtual = nomeSala;
  }
  
  async mover() {
    console.log("Locais disponíveis:");
    salasArray.forEach((s, index) => {
      console.log(`${index + 1}. ${s.nomesala}`);
    });
  
    const numeroSala = parseInt(prompt("Digite o número do local para onde deseja ir: "), 10) - 1;
  
    if (numeroSala < 0 || numeroSala >= salasArray.length) {
      console.log("Número do local inválido.");
      return;
    }
  
    const salaEncontrada = salasArray[numeroSala];
    this.salaAtual = salaEncontrada.nomesala;
    console.log(`\n========================= Você está em: ${this.salaAtual} =========================`);
    
    const updateQuery = `UPDATE CyberLutador SET fk_sala_atual = (SELECT idSala FROM Sala WHERE nomeSala = $1) WHERE idCyberLutador = $2;`;
  
    try {
      await pool.query(updateQuery, [this.salaAtual, this.id]);
  
      if (this.salaAtual.toLowerCase() === "SkyBar Holográfico".toLowerCase()) {
        await interagirComNeon(this.id);
      }
      if (this.salaAtual.toLowerCase() === "Beco Data Stream".toLowerCase()) {
        await interagirComShade(this.id);
      }
      if (this.salaAtual.toLowerCase() === "Laboratorio".toLowerCase()) {
        await interagirComCipher(this.id);
      }
  
      if (this.salaAtual.toLowerCase() === "Cyber Mercado".toLowerCase()) {
        const query = 
        `SELECT idMercadoClandestino FROM MercadoClandestino WHERE fk_sala = $1;`;
        const values = [salaEncontrada.idSala];
        const res = await pool.query(query, values);
        const idMercado = res.rows[0].idmercadoclandestino;
        await abrirMercado(idMercado, this);
      }
    } catch (error) {
      console.error("Erro ao tentar se deslocar:", error.message);
    }
  }
}

async function iniciarJogo() {
  await init();
  await carregarSalas();
  cyberlutadores = await getCyberLutadores();

  let personagem = null;
  let opcao;

  do {
    console.log("\n========================= Bem-vindo ao CyberBase =========================");
    console.log("1. Selecionar CyberLutador");
    console.log("2. Criar um CyberLutador");
    console.log("3. Ver informações do CyberLutador");
    console.log("4. Mover para outra sala");
    console.log("5. Iniciar Missão");
    console.log("6. Continuar Missão");
    console.log("7. Sair do jogo");
    opcao = prompt("Escolha uma opção: ");

    switch (opcao) {
      case "1":
        if (cyberlutadores.length === 0) {
          console.log("Não há cyberlutadores criados.");
          break;
        }
        console.log("Cyber Lutadores disponíveis:");
        cyberlutadores.forEach((c, index) => {
          console.log(`${index + 1}. Nome: ${c.nomecyberlutador}, Sala Atual: ${c.nomesala}`);
        });

        const escolha = parseInt(prompt("Escolha um cyberlutador: "), 10) - 1;
        if (escolha >= 0 && escolha < cyberlutadores.length) {
          const escolhido = cyberlutadores[escolha];
          personagem = new CyberLutador(escolhido.idcyberlutador, escolhido.nomecyberlutador, escolhido.nomesala);
          console.log(`Personagem ${personagem.nome} selecionado!`);
        } else {
          console.log("Escolha inválida.");
        }
        break;

      case "2":
        const nomeCyberLutador = prompt("Digite o nome do CyberLutador: ");
        const nomeSalaAtual = "Laboratorio";
      
        try {
          const querySala = `SELECT idSala FROM Sala WHERE nomeSala = $1 LIMIT 1;`;
          const valuesSala = [nomeSalaAtual];
    
          const resSala = await pool.query(querySala, valuesSala);
    
          if (resSala.rows.length === 0) {
            throw new Error('Sala não encontrada');
          }
    
          const fkSalaAtual = resSala.rows[0].idsala;
          console.log(`ID da sala "${nomeSalaAtual}": ${fkSalaAtual}`);
    
          const novoCyberLutador = await adicionarCyberLutador(nomeCyberLutador, fkSalaAtual);
          
          personagem = new CyberLutador(novoCyberLutador.idCyberLutador, novoCyberLutador.nomeCyberLutador, fkSalaAtual);
          console.log(`CyberLutador ${nomeCyberLutador} criado e posicionado na sala ${nomeSalaAtual}!`);
        } catch (error) {
          console.error("Erro ao criar o CyberLutador:", error.message);
        }
        break;

      case "3":
        if (!personagem) {
          console.log("Você precisa selecionar um CyberLutador primeiro.");
        } else {
          try {
            const query = `
              SELECT c.idcyberlutador, c.nomecyberlutador, c.inteligencia, c.resistencia, c.furtividade, 
                    c.percepcao, c.vida, c.velocidade, c.forca, s.nomesala
              FROM CyberLutador c
              JOIN Sala s ON c.fk_sala_atual = s.idSala
              WHERE c.idcyberlutador = $1;
            `;
            const values = [personagem.id];

            const res = await pool.query(query, values);
            if (res.rows.length > 0) {
              const cyberLutadorInfo = res.rows[0];
              console.log(`
                CyberLutador: ${cyberLutadorInfo.nomecyberlutador}
                Sala Atual: ${cyberLutadorInfo.nomesala}
                Força: ${cyberLutadorInfo.forca}
                Inteligência: ${cyberLutadorInfo.inteligencia}
                Velocidade: ${cyberLutadorInfo.velocidade}
                Furtividade: ${cyberLutadorInfo.furtividade}
                Percepção: ${cyberLutadorInfo.percepcao}
                Resistência: ${cyberLutadorInfo.resistencia}
                Vida: ${cyberLutadorInfo.vida}
              `);
            } else {
              console.log("CyberLutador não encontrado.");
            }
          } catch (error) {
            console.error("Erro ao buscar informações:", error.message);
          }
        }
        break;

      case "4":
        if (!personagem) {
          console.log("Selecione um CyberLutador primeiro.");
        } else {
          await personagem.mover();
        }
        break;

      case "5":
        if (!personagem) {
            console.log("Você precisa selecionar um CyberLutador primeiro.");
        } else if (personagem.salaAtual !== "Laboratorio") {
            console.log("Você precisa estar no Laboratório para iniciar a missão.");
        } else {
            // Verificar se já existe uma missão em andamento
            const query = `
                SELECT idMissao FROM Missao
                WHERE fk_cyberlutador = $1 AND progresso != 'Concluída';
            `;
            const res = await pool.query(query, [personagem.id]);

            if (res.rows.length > 0) {
                console.log("Você já tem uma missão em andamento. Use a opção 'Continuar Missão'.");
            } else {
                // Criar uma nova missão
                const insertQuery = `
                    INSERT INTO Missao (nomeMissao, objetivo, progresso, fk_sala, fk_cyberlutador)
                    VALUES ('Missão Principal', 'Recuperar o controle do sistema', '0/5', (SELECT idSala FROM Sala WHERE nomeSala = 'Laboratorio'), $1)
                    RETURNING idMissao;
                `;
                const insertRes = await pool.query(insertQuery, [personagem.id]);
                const idMissao = insertRes.rows[0].idmissao;

                await iniciarMissao(personagem, pool, idMissao);
            }
        }
        break;

      case "6":
        if (!personagem) {
            console.log("Você precisa selecionar um CyberLutador primeiro.");
        } else if (personagem.salaAtual !== "Laboratorio") {
            console.log("Você precisa estar no Laboratório para continuar a missão.");
        } else {
            const query = `
                SELECT idMissao FROM Missao
                WHERE fk_cyberlutador = $1 AND progresso != 'Concluída';
            `;
            const res = await pool.query(query, [personagem.id]);

            if (res.rows.length === 0) {
                console.log("Você não tem uma missão em andamento. Use a opção 'Iniciar Missão'.");
            } else {
                const idMissao = res.rows[0].idmissao;
                await iniciarMissao(personagem, pool, idMissao);
            }
        }
        break;

      case "7":
        console.log("Saindo do jogo...");
        break;

      default:
        console.log("Opção inválida.");
        break;
    }
  } while (opcao !== "7");
}

iniciarJogo();
