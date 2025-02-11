// mercado.js
const prompt = require('prompt-sync')();

const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',
  host: 'db',
  database: 'cyberbase',
  password: 'password',
  port: 5432,
});

async function abrirMercado(idMercado, personagem) {
  console.log("\nO que deseja fazer?\n");
  let opcao;
  do {
    console.log("1. Comprar itens");
    console.log("2. Sair do mercado");
    opcao = prompt("\nEscolha uma opção: ");
    
    switch (opcao) {
      case "1":
        await comprarItens(5, personagem);
        break;
      case "2":
        console.log("Saindo do mercado...");
        break;
      default:
        console.log("\nOpção inválida.");
    }
  } while (opcao !== "2");
}

async function comprarItens(idMercado, personagem) {
  const query = `
    SELECT 
      i.idItem,
      i.nomeItem,
      i.valor AS preco
    FROM Mercado_Item mi
    JOIN InstanciaItem ii ON mi.fk_instanciaitem = ii.idInstanciaItem
    JOIN Item i ON ii.fk_item = i.idItem
    WHERE mi.fk_mercado_clandestino = 1;
  `;
  
  try {
    const { rows } = await pool.query(query);

    if (rows.length === 0) {
      console.log("Este mercado não possui itens disponíveis.");
      return;
    }

    console.log("\nItens disponíveis no mercado:\n");

    let itemIds = [];
    rows.forEach((item, index) => {
      console.log(`${index + 1}. ${item.nomeitem} - ${item.preco}`);
      itemIds.push(item.iditem);
    });

    let escolha = parseInt(prompt("Digite o número do item que deseja comprar: "));
    
    if (isNaN(escolha) || escolha < 1 || escolha > itemIds.length) {
      console.log("Escolha inválida!");
      return;
    }
    
    let idItemEscolhido = itemIds[escolha - 1];
    console.log(`Você escolheu: ${rows[escolha - 1].nomeitem}`);

    const queryUpdate = `
      UPDATE Mochila 
      SET fk_instanciaitem = $1 
      WHERE fk_cyberlutador = $2
      RETURNING *;
    `;
    const values = [idItemEscolhido, personagem.id];

    await pool.query(queryUpdate, values);

    const updateQuery = `
      UPDATE Mercado_Item 
      SET fk_mercado_clandestino = NULL
      WHERE fk_instanciaitem = $1;
    `;
    await pool.query(updateQuery, [idItemEscolhido]);

    console.log("Item adquirido com sucesso!");

  } catch (error) {
    console.error("Erro ao listar os itens do mercado:", error.message);
  }
}


module.exports = { abrirMercado };
