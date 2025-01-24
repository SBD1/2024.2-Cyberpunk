const readline = require('readline');
const { init, getSalas, getCyberLutadores, adicionarCyberLutador } = require('./index'); // Importa a função getSalas

let cyberlutadores = [];

// Cria a interface readline
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

async function listarCyberLutadores() {
  try {
    cyberlutadores = await getCyberLutadores();
    if (!cyberlutadores) {
      console.log('Não há cyberlutadores criados');
    }
    else {
      console.log('Cyber Lutadores:')
      cyberlutadores.forEach(cyberlutador => {
        console.log(`ID: ${cyberlutador.idCyberLutador}, Nome: ${cyberlutador.nomeCyberLutador}, Sala atual: ${cyberlutador.fk_sala_atual}`);
      });
    }
  } catch (error) {
    console.error('Erro ao buscar cyberlutadores:', error);
  }
}

async function listarSalas() {
  try {
    const salas = await getSalas(); // Chama a função para obter as salas
    console.log('Informações das Salas:');
    salas.forEach(sala => {
      // console.log(sala);
      console.log(`ID: ${sala.idsala}, Nome: ${sala.nomesala}, Norte: ${sala.norte}, Sul: ${sala.sul}, Leste: ${sala.leste}, Oeste: ${sala.oeste}`);
    });
  } catch (error) {
    console.error('Erro ao exibir as salas:', error);
  }
}

class CyberLutador {
  constructor(nome, salaAtual) {
    this.nome = nome;
    this.salaAtual = salaAtual;
  }

  // andar(novaSala) {
  //   if (this.salaAtual.conexoes.includes(novaSala)) {
  //     this.salaAtual = novaSala;
  //     console.log(`Você andou para a sala: ${novaSala.nome}`);
  //   }
  // }
  mover(direcao) {
    const novaSala = this.salaAtual.conexoes[direcao];
    if (novaSala) {
      this.salaAtual = novaSala;
      console.log(`Você andou para a sala: ${novaSala.nome}`);
    } else {
      console.log(`Não é possível ir para o ${direcao}.`);
    }
  }
}

class Sala {
  constructor(nome, norte, sul, leste, oeste = {}) {
    this.nome = nome;
    // Conexões: norte, sul, leste, oeste
    this.norte = norte || null;
    this.sul = sul || null;
    this.leste = leste || null;
    this.oeste = oeste || null;
  }

  // Método para definir conexões
  definirConexoes(norte, sul, leste, oeste) {
    this.norte = { ...this.norte, norte };
    this.sul = { ...this.sul, sul };
    this.leste = { ...this.leste, leste };
    this.oeste = { ...this.oeste, oeste };
  }
}

async function iniciarJogo() {
  let personagem = null;

  const prompt = require('prompt-sync')();
  let opcao;

  do {
    console.log("\n=== Bem-vindo ===");
    console.log("1. Selecionar CyberLutador");
    console.log("2. Criar um CyberLutador");
    console.log("3. Ver informações do CyberLutador");
    console.log("4. Mover para outra sala");
    console.log("5. Sair do jogo");
    opcao = prompt("Escolha uma opção: ");

    switch (opcao) {
      case "1":
        if (!cyberlutadores || cyberlutadores.length <= 0) {
          await listarCyberLutadores();
          console.log("Não há cyberlutadores criados.");
        } else {
          const escolha = parseInt(prompt("Escolha um cyberlutador"), 10) - 1;
          if (escolha >= 0 && escolha < cyberlutadores.length) {
            personagem = new CyberLutador(cyberlutadores[escolha].nomeCyberLutador, cyberlutadores[escolha].fk_sala_atual)
          }
          const nome = prompt("Digite o nome do seu CyberLutador: ");
          personagem = new CyberLutador(nome, sala1);
          console.log(`Personagem ${nome} criado! Você está na sala: ${sala1.nome}`);
        }
        break;

      case "2":
        const nomeCyberLutador = prompt("Digite o nome do CyberLutador: ");
        const fkSalaAtual = 1;

        try {
          const novoCyberLutador = await adicionarCyberLutador(nomeCyberLutador, fkSalaAtual);
          console.log("\n=== CyberLutador Criado ===");
          console.log(`ID: ${novoCyberLutador.idCyberLutador}`);
          console.log(`Nome: ${novoCyberLutador.nomeCyberLutador}`);
          console.log(`Sala Inicial: ${novoCyberLutador.fk_sala_atual}`);
          console.log(`Atributos: 
            Inteligência: ${novoCyberLutador.inteligencia},
            Resistência: ${novoCyberLutador.resistencia},
            Furtividade: ${novoCyberLutador.furtividade},
            Percepção: ${novoCyberLutador.percepcao},
            Vida: ${novoCyberLutador.vida},
            Velocidade: ${novoCyberLutador.velocidade},
            Força: ${novoCyberLutador.forca}`);
        } catch (error) {
          console.error("Erro ao criar o CyberLutador:", error.message);
        }

        break;

      case "3":
        if (personagem) {
          console.log("\n=== Salas disponíveis ===");
          personagem.salaAtual.conexoes.forEach((sala, index) => {
            console.log(`${index + 1}. ${sala.nome} - ${sala.descricao}`);
          });
          const escolha = parseInt(prompt("Escolha uma sala para ir: "), 10) - 1;
          if (escolha >= 0 && escolha < personagem.salaAtual.conexoes.length) {
            personagem.andar(personagem.salaAtual.conexoes[escolha]);
          } else {
            console.log("Escolha inválida.");
          }
        } else {
          console.log("Você precisa criar um personagem antes de se mover.");
        }
        break;

      case "4":

        break;

      case "5":

        break;

      default:
    }
  } while (opcao !== "5");
}

// Inicia o menu
iniciarJogo();
