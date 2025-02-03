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
          const query = 
          `SELECT idMercadoClandestino FROM MercadoClandestino WHERE fk_sala = $1;`;
          const values = [salaEncontrada.idsala];
          const res = await pool.query(query, values);
          const idMercado = res.rows[0].idmercadoclandestino;
          await this.abrirMercado(idMercado);
        }
      } catch (error) {
        console.error("Erro ao mover para a sala:", error.message);
    }
  }

  async abrirMercado(idMercado) {
    console.log("Você entrou no Cyber Mercado!");
    let opcao;
    do {
    console.log("1. Comprar itens");
    //console.log("2. Vender itens");
    console.log("2. Sair do mercado");
    opcao = prompt("Escolha uma opção: ");
    
    switch (opcao) {
      case "1":
          const query = `
              SELECT 
                  i.idItem,
                  i.nomeItem,
                  i.valor AS preco
              FROM Mercado_Item mi
              JOIN InstanciaItem ii ON mi.fk_instanciaitem = ii.idInstanciaItem
              JOIN Item i ON ii.fk_item = i.idItem
              WHERE mi.fk_mercado_clandestino = $1;
          `;
  
          try {
              const { rows } = await pool.query(query, [idMercado]);
  
              if (rows.length === 0) {
                  console.log("Este mercado não possui itens disponíveis.");
                  return;
              }
  
              console.log("\n Itens disponíveis no mercado:\n");
  
              // Armazena os IDs dos itens disponíveis
              let itemIds = [];
  
              rows.forEach((item, index) => {
                  console.log(`${index + 1}. ${item.nomeitem} - 💰 ${item.preco}`);
                  itemIds.push(item.iditem); // Guarda os IDs dos itens
              });

              let escolha = parseInt(prompt("\nDigite o número do item que deseja comprar: "));
  
              // Verificar se a escolha é válida
              if (isNaN(escolha) || escolha < 1 || escolha > itemIds.length) {
                  console.log("Escolha inválida!");
                  return;
              }
  
              let idItemEscolhido = itemIds[escolha - 1]; // Pega o ID correspondente
  
              console.log(`Você escolheu: ${rows[escolha - 1].nomeitem}`);
  
              const queryUpdate = `
                  UPDATE Mochila 
                  SET fk_instanciaitem = $1 
                  WHERE fk_cyberlutador = $2
                  RETURNING *;
              `;
              const values = [idItemEscolhido, idCyberLutador];
  
              const resultado = await pool.query(queryUpdate, values);

              const query = `
              UPDATE Mercado_Item 
              SET fk_mercado_clandestino = NULL
              WHERE fk_instanciaitem = $1;
              `
              const valor = [idItemEscolhido];
              await pool.query(query, values);

              console.log("Item adquirido com sucesso!");

    } catch (error) {
        console.error("Erro ao listar os itens do mercado:", error.message);
    }
        break;
//      case "2":
//        await this.venderItens();
//        break;
      case "2":
        console.log("Saindo do mercado...");
        break;
      default:
        console.log("Opção inválida.");
    }
  } while (opcao !== "2");

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