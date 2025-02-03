const { Pool } = require('pg');
const prompt = require('prompt-sync')();

const pool = new Pool({
  user: 'postgres',
  host: 'db',
  database: 'cyberbase',
  password: 'password',
  port: 5432,
});

const { init, getSalas, getCyberLutadores, adicionarCyberLutador } = require('./index');

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
    console.log("Salas disponíveis:");
    salasArray.forEach((s, index) => {
        console.log(`${index + 1}. ${s.nomesala}`);
    });

    const novaSalaNome = prompt("Digite o nome da sala para onde deseja ir: ");
    
    const salaEncontrada = salasArray.find(s => s.nomesala === novaSalaNome);

    if (!salaEncontrada) {
        console.log("Sala não encontrada.");
        return;
    }

    this.salaAtual = novaSalaNome;
    console.log(`\nVocê está em: ${novaSalaNome}`);
    
    const updateQuery = `UPDATE CyberLutador SET fk_sala_atual = (SELECT idSala FROM Sala WHERE nomeSala = $1) WHERE idCyberLutador = $2;`;

    try {
        await pool.query(updateQuery, [novaSalaNome, this.id]);
    } catch (error) {
        console.error("Erro ao mover para a sala:", error.message);
    }
  }
}

function gerarPuzzleMatematico() {
  const num1 = Math.floor(Math.random() * 500) + 100;
  const num2 = Math.floor(Math.random() * 500) + 100;
  const operacoes = ['+', '-', '*', '/'];
  const operacao = operacoes[Math.floor(Math.random() * operacoes.length)];
  let resultado;

  switch (operacao) {
    case '+': resultado = num1 + num2; break;
    case '-': resultado = num1 - num2; break;
    case '*': resultado = num1 * num2; break;
    case '/': resultado = Math.floor(num1 / num2); break;
  }

  return { pergunta: `Resolva: ${num1} ${operacao} ${num2}`, resposta: resultado };
}

function gerarPuzzleDecodificador() {
  const palavrasCyberpunk = ['neon', 'hacker', 'android', 'implante', 'circuito', 'ciborgue', 'edgerunner'];
  const palavraEscolhida = palavrasCyberpunk[Math.floor(Math.random() * palavrasCyberpunk.length)];
  
  const alfabeto = 'abcdefghijklmnopqrstuvwxyz';
  const mapeamento = {};
  let numero = 1;

  for (const letra of alfabeto) {
    mapeamento[letra] = numero;
    numero++;
  }

  let palavraCodificada = '';
  for (const letra of palavraEscolhida) {
    palavraCodificada += mapeamento[letra] + ' ';
  }

  return { dica: 'Cada letra do alfabeto corresponde a um número.', palavraCodificada, resposta: palavraEscolhida };
}

async function iniciarMissao(cyberLutador) {
  console.log("\n=== Você iniciou uma missão! ===");

  const historiaMissao = 
  `Você foi convocado para uma missão crítica. Um sistema de inteligência artificial,
  projetado para controlar as cidades cibernéticas, foi hackeado por uma facção desconhecida.
  Seu objetivo é recuperar o controle do sistema resolvendo puzzles complexos.

  A missão está dividida em dois desafios:
  1. Resolva um puzzle matemático para hackear os sistemas de segurança.
  2. Decodifique uma palavra codificada para liberar os dados secretos da facção.

  Cada passo certo aproxima você do sucesso. Boa sorte, CyberLutador!`;
  console.log(historiaMissao);

  const tipoPuzzle = Math.random() > 0.5 ? 'matematica' : 'decodificador';
  let puzzle;

  if (tipoPuzzle === 'matematica') {
      puzzle = gerarPuzzleMatematico();
      console.log(puzzle.pergunta);
  } else {
      puzzle = gerarPuzzleDecodificador();
      console.log(puzzle.dica);
      console.log(`Palavra codificada: ${puzzle.palavraCodificada}`);
  }

  const respostaJogador = prompt("Digite sua resposta: ");
  if (respostaJogador.toLowerCase() === String(puzzle.resposta).toLowerCase()) {
      console.log("Parabéns! Você resolveu o puzzle.");
  } else {
      console.log("Resposta incorreta.");
  }
}

async function iniciarJogo() {
  await init();
  await carregarSalas();
  cyberlutadores = await getCyberLutadores();

  let personagem = null;
  let opcao;

  do {
    console.log("\n=== Bem-vindo ao CyberBase ===");
    console.log("1. Selecionar CyberLutador");
    console.log("2. Criar um CyberLutador");
    console.log("3. Ver informações do CyberLutador");
    console.log("4. Mover para outra sala");
    console.log("5. Iniciar Missão");
    console.log("6. Sair do jogo");
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

            if (res.rows.length === 0) {
              console.log("CyberLutador não encontrado.");
              return;
            }

            const cyberLutador = res.rows[0];
            
            console.log("\n=== Informações do CyberLutador ===");
            console.log(`Nome: ${cyberLutador.nomecyberlutador}`);
            console.log(`Sala Atual: ${cyberLutador.nomesala}`);
            console.log(`ID: ${cyberLutador.idcyberlutador}`);
            console.log(`Inteligência: ${cyberLutador.inteligencia}`);
            console.log(`Resistência: ${cyberLutador.resistencia}`);
            console.log(`Furtividade: ${cyberLutador.furtividade}`);
            console.log(`Percepção: ${cyberLutador.percepcao}`);
            console.log(`Vida: ${cyberLutador.vida}`);
            console.log(`Velocidade: ${cyberLutador.velocidade}`);
            console.log(`Força: ${cyberLutador.forca}`);
            
          } catch (error) {
            console.error("Erro ao buscar informações do CyberLutador:", error.message);
          }
        }
        break;

      case "4":
        if (!personagem) {
          console.log("Você precisa selecionar um CyberLutador primeiro.");
          break;
        }
        await personagem.mover();
        break;
      
      case "5":
        if (!personagem) {
            console.log("Você precisa selecionar um CyberLutador primeiro.");
        } else if (personagem.salaAtual !== "Laboratorio") {
            console.log("Você precisa estar no Laboratório para iniciar a missão.");
        } else {
            await iniciarMissao(personagem);
        }
        break;

      case "6":
          console.log("Saindo do jogo...");
          break;

      default:
          console.log("Opção inválida.");
          break;
      
    }
  } while (opcao !== "6");
}

iniciarJogo();