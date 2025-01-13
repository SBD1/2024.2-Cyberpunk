class Regiao {
  constructor(nome, salas = []) {
    this.nome = nome;
    this.salas = salas;
  }
}

class Sala {
  constructor(nome, descricao = '', conexoes = []) {
    this.nome = nome;
    this.descricao = descricao;
    this.conexoes = conexoes;
  }
}

class CyberLutador {
  constructor(nome, salaAtual) {
    this.nome = nome;
    this.salaAtual = salaAtual;
  }

  andar(novaSala) {
    if (this.salaAtual.conexoes.includes(novaSala)) {
      this.salaAtual = novaSala;
      console.log(`Você andou para a sala: ${novaSala.nome}`);
    }
  }
}

const sala1 = new Sala("Sala 1", "Laboratório");
const sala2 = new Sala("Sala 2", "Ruínas");
const sala3 = new Sala("Sala 3", "Distrito Neon");
sala1.conexoes.push(sala2);
sala2.conexoes.push(sala1, sala3);
sala3.conexoes.push(sala2);

const regiao = new Regiao("Região Central", [sala1, sala2, sala3]);

function iniciarJogo() {
  let personagem = null;

  const prompt = require('prompt-sync')();
  let opcao;

  do {
    console.log("\n=== Bem-vindo ===");
    console.log("1. Criar um personagem");
    console.log("2. Ver informações do personagem");
    console.log("3. Mover para outra sala");
    console.log("4. Sair do jogo");
    opcao = prompt("Escolha uma opção: ");

    switch (opcao) {
      case "1":
        if (personagem) {
          console.log("Você já criou um personagem.");
        } else {
          const nome = prompt("Digite o nome do seu CyberLutador: ");
          personagem = new CyberLutador(nome, sala1);
          console.log(`Personagem ${nome} criado! Você está na sala: ${sala1.nome}`);
        }
        break;

      case "2":
        if (personagem) {
          console.log(`\n=== Informações do personagem ===`);
          console.log(`Nome: ${personagem.nome}`);
          console.log(`Sala atual: ${personagem.salaAtual.nome}`);
          console.log(`Descrição: ${personagem.salaAtual.descricao}`);
        } else {
          console.log("Você ainda não criou um personagem.");
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
        console.log("Saindo do jogo. Até a próxima!");
        break;

      default:
        console.log("Opção inválida. Tente novamente.");
    }
  } while (opcao !== "4");
}

iniciarJogo();
