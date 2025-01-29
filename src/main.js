const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',
  host: 'db',
  database: 'cyberbase',
  password: 'password',
  port: 5432,
})
const prompt = require('prompt-sync')();
const { init, getSalas, getCyberLutadores, adicionarCyberLutador } = require('./index');

let cyberlutadores = [];
let salas = {};

async function carregarSalas() {
  const salasArray = await getSalas();
  salasArray.forEach(sala => {
    salas[sala.idSala] = {
      id: sala.idSala,
      nome: sala.nomeSala,
      conexoes: {
        norte: sala.norte || null,
        sul: sala.sul || null,
        leste: sala.leste || null,
        oeste: sala.oeste || null
      }
    };
  });
}

class CyberLutador {
  constructor(idcyberlutador, nomecyberLutador, nomeSala) {
    this.id = idcyberlutador;
    this.nome = nomecyberLutador;
    this.salaAtual = nomeSala;
  }

  mover(direcao) {
    const novaSalaId = salas[this.salaAtual].conexoes[direcao];
    if (novaSalaId) {
      this.salaAtual = novaSalaId;
      console.log(`Você se moveu para a sala: ${salas[this.salaAtual].nomeSala}`);
    } else {
      console.log(`Não é possível ir para ${direcao}.`);
    }
  }

  exibirMapa() {
    const mapa = ["( )", "( )", "( )", "( )"];
    const direcoes = ["norte", "sul", "leste", "oeste"];

    direcoes.forEach((dir, index) => {
      if (salas[this.salaAtual].conexoes[dir]) {
        mapa[index] = "(x)";
      }
    });

    console.log(`Mapa da sala ${salas[this.salaAtual].nomeSala}:`);
    console.log(`  ${mapa[0]}  `);
    console.log(`${mapa[3]} (x) ${mapa[2]}`);
    console.log(`  ${mapa[1]}  `);
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
    console.log("5. Sair do jogo");
    opcao = prompt("Escolha uma opção: ");

    switch (opcao) {
      case "1":
        if (cyberlutadores.length === 0) {
          console.log("Não há cyberlutadores criados.");
          break;
        }
        console.log("Cyber Lutadores disponíveis:");
        // console.log("Cyber Lutadores disponíveis: " + JSON.stringify(cyberlutadores[0].nomecyberlutador));

        cyberlutadores.forEach((c, index) => {
          console.log(`${index + 1}. Nome: ${c.nomecyberlutador}, Sala Atual: ${c.nomesala}`);
        });

        const escolha = parseInt(prompt("Escolha um cyberlutador: "), 10) - 1;
        if (escolha >= 0 && escolha < cyberlutadores.length) {
          const escolhido = cyberlutadores[escolha];
          personagem = new CyberLutador(escolhido.idcyberLutador, escolhido.nomecyberLutador, escolhido.nomeSala);
          console.log(`Personagem ${personagem.nome} selecionado!`);
          personagem.exibirMapa();
        } else {
          console.log("Escolha inválida.");
        }
        break;
        case "2":
          const nomeCyberLutador = prompt("Digite o nome do CyberLutador: ");
          const nomeSalaAtual = "Laboratorio";
        
          try {
            const querySala = `
              SELECT idSala FROM Sala WHERE nomeSala = $1 LIMIT 1;
            `;
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
            // personagem.exibirMapa();
          } catch (error) {
            console.error("Erro ao criar o CyberLutador:", error.message);
          }
          break;
          
      case "4":
        if (!personagem) {
          console.log("Você precisa selecionar um CyberLutador primeiro.");
          break;
        }

        console.log("Movimentos disponíveis:");
        for (const direcao in salas[personagem.salaAtual].conexoes) {
          if (salas[personagem.salaAtual].conexoes[direcao]) {
            console.log(`- ${direcao.toUpperCase()} para ${salas[salas[personagem.salaAtual].conexoes[direcao]].nome}`);
          }
        }

        const direcao = prompt("Digite a direção (norte, sul, leste, oeste): ").toLowerCase();
        personagem.mover(direcao);
        personagem.exibirMapa();
        break;

      case "5":
        console.log("Saindo do jogo...");
        break;

      default:
        console.log("Opção inválida.");
    }
  } while (opcao !== "5");
}

iniciarJogo();
