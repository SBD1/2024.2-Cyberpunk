const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',
  host: 'db',
  database: 'cyberbase',
  password: 'password',
  port: 5432,
});

const prompt = require('prompt-sync')();
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
        console.log(`${index + 1}.${s.nomesala}`);
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
        
        if (novaSalaNome.toLowerCase() === "Cyber Mercado".toLowerCase()) {
          await this.abrirMercado();
        }
      } catch (error) {
        console.error("Erro ao mover para a sala:", error.message);
    }
  }

  async abrirMercado() {
    console.log("Você entrou no Cyber Mercado!");
    let opcao;
    do {
    console.log("1. Comprar itens");
    console.log("2. Vender itens");
    console.log("3. Sair do mercado");
    opcao = prompt("Escolha uma opção: ");
    
    switch (opcao) {
      case "1":
        await this.comprarItens();
        break;
      case "2":
        await this.venderItens();
        break;
      case "3":
        console.log("Saindo do mercado...");
        break;
      default:
        console.log("Opção inválida.");
    }
  } while (opcao !== "3");

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
        cyberlutadores.forEach((c, index) => {
          console.log(`${index + 1}. Nome: ${c.nomecyberlutador}, Sala Atual: ${c.nomesala}`);
        });

        const escolha = parseInt(prompt("Escolha um cyberlutador: "), 10) - 1;
        if (escolha >= 0 && escolha < cyberlutadores.length) {
          const escolhido = cyberlutadores[escolha];
          personagem = new CyberLutador(escolhido.idcyberlutador, escolhido.nomecyberlutador, escolhido.nomesala);
          console.log("personagem", personagem);
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
        await personagem.mover(salasArray);

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