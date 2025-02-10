const { Pool } = require('pg');
const prompt = require('prompt-sync')();

const pool = new Pool({
    user: 'postgres',
    host: 'db',
    database: 'cyberbase',
    password: 'password',
    port: 5432,
});

async function obterDialogoNPC(nomeNPC, nomeDialogo) {
    try {
        const res = await pool.query(
            `SELECT nomeDialogo, descricao 
            FROM Dialogo 
            WHERE fk_npc = (SELECT idNPC FROM NPC WHERE nomeNPC = $1 LIMIT 1) 
            AND nomeDialogo = $2
            LIMIT 1`, [nomeNPC, nomeDialogo]);
        
        if (res.rows.length > 0) {
            const { nomedialogo, descricao } = res.rows[0];
            return { nomedialogo, descricao };
        } else {
            return { nomedialogo: 'Conselho não encontrado', descricao: `${nomeNPC} não tem nenhum conselho para oferecer agora.` };
        }
    } catch (err) {
        console.error(`Erro ao buscar diálogo de ${nomeNPC}:`, err);
        return { nomeDialogo: 'Erro', descricao: `${nomeNPC} não tem nenhum conselho para oferecer agora.` };
    }
}
async function interagirComNPC(nomeNPC, nomeDialogo, opcoes, idCyberLutador) {
	let continuarInteracao = true;
	while (continuarInteracao) {
			console.log("\n=====", `Você encontrou ${nomeNPC}`, "=====\n");
			opcoes.forEach((opcao, index) => {
					console.log(`${index + 1}. ${opcao}`);
			});

			const opcaoNPC = prompt("\nEscolha uma opção: ");

			switch (opcaoNPC) {
					case "1":
							if (nomeNPC === "Neon") {
									console.log("\nNeon serve uma marguerita e diz: 'Aqui, um brinde pode valer mais que ouro.'");
							} else if (nomeNPC === "Shade") {
									console.log("\nShade te oferece uma bebida escura e forte, com um sorriso enigmático.");
							} else if (nomeNPC === "Dr. Cipher") {
									console.log("\nDr. Cipher ajusta seus óculos e diz: 'Você escolheu a ciência, beba esse conhecimento.'");
							}
							break;
					case "2":
							const { nomedialogo, descricao } = await obterDialogoNPC(nomeNPC, nomeDialogo);
							console.log(`\n${nomedialogo}\n\n${descricao}`);
							if (nomeNPC === "Neon") {
									await atualizarAtributosCyberLutador(idCyberLutador, 'Neon');
							} else if(nomeNPC === "Shade") {
									await atualizarAtributosCyberLutador(idCyberLutador, 'Shade');
							}
							break;
					case "3":
						if (nomeNPC === "Neon") {
								console.log("\nNeon te olha com um sorriso enigmático e diz: 'O destino é um jogo, você apenas precisa decidir qual aposta fazer.'");
						} else if (nomeNPC === "Shade") {
								console.log("\nShade te observa com seus olhos penetrantes e murmura: 'O destino... ou você o controla, ou ele o controla.'");
						} else if (nomeNPC === "Dr. Cipher") {
								console.log("\nDr. Cipher olha para você com uma expressão analítica e diz: 'O destino é feito de códigos, e você precisa entender como programá-lo.'");
						}
						break;
					case "4":
							console.log("\nVocê decidiu encerrar a interação.");
							continuarInteracao = false;
							break;
					default:
							console.log("\nOpção inválida. Tente novamente.");
							break;
			}
	}
}

async function interagirComNeon(idCyberLutador) {
    const opcoes = [
        "Pedir um drink",
        "Pedir um conselho",
        "Perguntar sobre o destino",
        "Não interagir"
    ];
    await interagirComNPC('Neon', 'Bem-vindo ao SkyBar. Aqui, um brinde pode valer mais que ouro.', opcoes, idCyberLutador);
}

async function interagirComShade(idCyberLutador) {
    const opcoes = [
        "Olhar para Shade",
        "Pedir informações sobre o submundo",
        "Perguntar sobre o destino",
        "Não interagir"
    ];
    await interagirComNPC('Shade', 'A informação não é só poder, é a única moeda que realmente importa.', opcoes, idCyberLutador);
}

async function interagirComCipher(idCyberLutador) {
    const opcoes = [
        "Olhar para Dr. Cipher",
        "Pedir conselhos científicos",
        "Perguntar sobre o destino",
        "Não interagir"
    ];
    await interagirComNPC('Dr. Cipher', 'Então, você quer respostas?', opcoes, idCyberLutador);
}

async function atualizarAtributosCyberLutador(idCyberLutador, nomeNPC) {
    const verificarAtributosQuery = 
        `SELECT vida, inteligencia, resistencia, furtividade, percepcao 
        FROM CyberLutador 
        WHERE idCyberLutador = $1`;

    const obterIncrementosQuery = 
        `SELECT aumentaInteligencia, aumentaFurtividade, aumentaPercepcao 
        FROM Mentor 
        WHERE fk_npc = (SELECT idNPC FROM NPC WHERE nomeNPC = $1) LIMIT 1`;

    // console.log("idCyberLutador", idCyberLutador, "nomeNPC", nomeNPC);

    try {
        const resultadoAtributos = await pool.query(verificarAtributosQuery, [idCyberLutador]);
        if (resultadoAtributos.rows.length === 0) {
            console.error("CyberLutador não encontrado.");
            return;
        }

        const { inteligencia, furtividade, percepcao } = resultadoAtributos.rows[0];

        // console.log("Atributos do CyberLutador:", { inteligencia, furtividade, percepcao });

        const resultadoIncrementos = await pool.query(obterIncrementosQuery, [nomeNPC]);

        // console.log("Resultado dos Incrementos:", resultadoIncrementos.rows);

        if (resultadoIncrementos.rows.length === 0) {
            console.error(`Nenhum mentor encontrado para o NPC ${nomeNPC}.`);
            return;
        }

        const { aumentainteligencia, aumentafurtividade, aumentapercepcao } = resultadoIncrementos.rows[0];

        // console.log(`Incrementos de Mentor para ${nomeNPC}:`, { aumentainteligencia, aumentafurtividade, aumentapercepcao });

        if (aumentainteligencia === undefined || aumentafurtividade === undefined || aumentapercepcao === undefined) {
            console.error(`Os incrementos para o NPC ${nomeNPC} estão indefinidos.`);
            return;
        }

        const novaInteligencia = (parseInt(inteligencia) || 0) + (parseInt(aumentainteligencia) || 0);
        const novaFurtividade = (parseInt(furtividade) || 0) + (parseInt(aumentafurtividade) || 0);
        const novaPercepcao = (parseInt(percepcao) || 0) + (parseInt(aumentapercepcao) || 0);

        // console.log("Novos atributos calculados:", { novaInteligencia, novaFurtividade, novaPercepcao });

        const updateAtributosQuery = 
            `UPDATE CyberLutador
            SET inteligencia = $1, furtividade = $2, percepcao = $3
            WHERE idCyberLutador = $4`;

        await pool.query(updateAtributosQuery, [
            novaInteligencia, novaFurtividade, novaPercepcao, idCyberLutador
        ]);

        // const atributosAtualizados = await pool.query(verificarAtributosQuery, [idCyberLutador]);

        console.log("\nSua inteligência aumentou em", aumentainteligencia);
				console.log("Sua percepção aumentou em", aumentapercepcao);
        console.log("Sua furtividade aumentou em", aumentafurtividade);

        // console.log("Inteligência:", atributosAtualizados.rows[0].inteligencia);
        // console.log("Furtividade:", atributosAtualizados.rows[0].furtividade);
        // console.log("Percepção:", atributosAtualizados.rows[0].percepcao);

    } catch (err) {
        console.error("Erro ao atualizar os atributos:", err);
    }
}

module.exports = { interagirComNeon, interagirComShade, interagirComCipher };
