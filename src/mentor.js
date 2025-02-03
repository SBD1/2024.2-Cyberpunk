const { Pool } = require('pg');
const prompt = require('prompt-sync')();

const pool = new Pool({
    user: 'postgres',
    host: 'db',
    database: 'cyberbase',
    password: 'password',
    port: 5432,
});

// Busca o mentor da sala atual
async function buscarMentorDaSala(idSala) {
    const client = await pool.connect();
    try {
        const result = await client.query('SELECT idMentor, fk_npc FROM Mentor WHERE fk_sala = $1', [idSala]);
        return result.rows.length > 0 ? result.rows[0] : null;
    } catch (error) {
        console.error("Erro ao buscar mentor:", error.message);
        return null;
    } finally {
        client.release();
    }
}

// Busca o nome do NPC (mentor)
async function buscarNomeNPC(idNPC) {
    const client = await pool.connect();
    try {
        const result = await client.query('SELECT nomeNPC FROM NPC WHERE idNPC = $1', [idNPC]);
        return result.rows.length > 0 ? result.rows[0].nomenpc : "NPC desconhecido";
    } catch (error) {
        console.error("Erro ao buscar nome do NPC:", error.message);
        return "NPC desconhecido";
    } finally {
        client.release();
    }
}

// Busca os diálogos do mentor
async function buscarDialogo(idNPC) {
    const client = await pool.connect();
    try {
        const result = await client.query('SELECT nomeDialogo FROM Dialogo WHERE fk_npc = $1', [idNPC]);
        return result.rows.map(row => row.nomedialogo);
    } catch (error) {
        console.error("Erro ao buscar diálogos:", error.message);
        return [];
    } finally {
        client.release();
    }
}

// Busca os atributos que o mentor pode conceder
async function buscarAtributosMentor(idMentor) {
    const client = await pool.connect();
    try {
        const result = await client.query(`
            SELECT aumentaInteligencia, aumentaFurtividade, aumentaPercepcao 
            FROM Mentor 
            WHERE idMentor = $1`, [idMentor]);

        return result.rows[0] || { aumentaInteligencia: 0, aumentaFurtividade: 0, aumentaPercepcao: 0 };
    } catch (error) {
        console.error("Erro ao buscar atributos do mentor:", error.message);
        return { aumentaInteligencia: 0, aumentaFurtividade: 0, aumentaPercepcao: 0 };
    } finally {
        client.release();
    }
}

// Obtém o CyberLutador que está interagindo na sala
async function buscarCyberLutadorNaSala(idSala) {
    const client = await pool.connect();
    try {
        const result = await client.query(`
            SELECT idCyberLutador FROM CyberLutador WHERE fk_sala = $1 LIMIT 1`, [idSala]);

        return result.rows.length > 0 ? result.rows[0].idcyberlutador : null;
    } catch (error) {
        console.error("Erro ao buscar CyberLutador:", error.message);
        return null;
    } finally {
        client.release();
    }
}

// Atualiza os atributos do CyberLutador
async function atualizarAtributosCyberLutador(idCyberLutador, atributos) {
    const client = await pool.connect();
    try {
        const query = `
            UPDATE CyberLutador 
            SET inteligencia = inteligencia + $1, 
                furtividade = furtividade + $2, 
                percepcao = percepcao + $3 
            WHERE idCyberLutador = $4
            RETURNING *;
        `;
        const values = [atributos.aumentaInteligencia, atributos.aumentaFurtividade, atributos.aumentaPercepcao, idCyberLutador];

        const result = await client.query(query, values);
        console.log("\nAtributos atualizados com sucesso!\nNovo status do jogador:");
        console.table(result.rows[0]);
    } catch (error) {
        console.error("Erro ao atualizar os atributos do CyberLutador:", error.message);
    } finally {
        client.release();
    }
}

// Interação com o mentor
async function interagirComMentor(idSala) {
    const mentor = await buscarMentorDaSala(idSala);
    if (!mentor) {
        console.log("Nenhum mentor nesta sala."); // Apenas para debug
        return;
    }

    const nomeNPC = await buscarNomeNPC(mentor.fk_npc);
    const dialogos = await buscarDialogo(mentor.fk_npc);
    const atributosMentor = await buscarAtributosMentor(mentor.idmentor);
    const idCyberLutador = await buscarCyberLutadorNaSala(idSala);

    if (!idCyberLutador) {
        console.log("Nenhum CyberLutador encontrado nesta sala.");
        return;
    }

    console.log(`\nVocê encontrou ${nomeNPC}!`);
    console.log("\nDiálogo:");
    dialogos.forEach((fala, index) => {
        console.log(`${index + 1}: ${fala}`);
    });

    await atualizarAtributosCyberLutador(idCyberLutador, atributosMentor);
}

module.exports = { interagirComMentor };
