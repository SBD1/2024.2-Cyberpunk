const { Pool } = require('pg');

const pool = new Pool({
    user: 'postgres',
    host: 'db',
    database: 'cyberbase',
    password: 'password',
    port: 5432,
});

async function getIdSalaPadrao() {
    const res = await pool.query(
        'SELECT idSala FROM Sala WHERE nomeSala = $1', 
        ['Laboratorio']
    );
    return res.rows[0]?.idsala;
}

async function fetchCombatants(idCyberLutador, idInstanciaInimigo, idSala) {
    const client = await pool.connect();
    try {
        const cyberQuery = `
            SELECT idCyberLutador, nomeCyberLutador, vida, forca 
            FROM CyberLutador 
            WHERE idCyberLutador = $1`;

        const enemyQuery = `
            SELECT i.qtdDano AS qtddano, i.vida 
            FROM InstanciaInimigo ii
            JOIN Inimigo i ON ii.fk_inimigo = i.idInimigo
            JOIN NPC n ON i.fk_npc = n.idNPC
            JOIN Sala s ON n.fk_sala = s.idSala
            WHERE ii.idInstanciaInimigo = $1 AND s.idSala = $2`;

        const [cyberResult, enemyResult] = await Promise.all([
            client.query(cyberQuery, [idCyberLutador]),
            client.query(enemyQuery, [idInstanciaInimigo, idSala])
        ]);

        if (!cyberResult.rows[0]) throw new Error('CyberLutador não encontrado');
        if (!enemyResult.rows[0]) throw new Error('Inimigo não encontrado nesta sala');

        return {
            cyber: cyberResult.rows[0],
            enemy: enemyResult.rows[0]
        };
    } catch (error) {
        console.log("Erro ao buscar combatentes:", error.message); 
        throw error; 
    } finally {
        client.release();
    }
}

async function battleInterface(prompt, cyber, enemy) {
    console.log(`\n=== BATALHA: ${cyber.nomecyberlutador} vs Inimigo ===`);
    
    let combatActive = true;
    
    while (combatActive && cyber.vida > 0 && enemy.vida > 0) {
        console.log(`\nSua vida: ${cyber.vida} | Vida do inimigo: ${enemy.vida}`);
        console.log("1. Atacar");
        console.log("2. Fugir");
        const choice = prompt("Escolha uma ação: ");

        switch(choice) {
            case "1":
                console.log(`\nVocê ataca causando ${cyber.forca} de dano!`);
                enemy.vida -= cyber.forca;
                
                if (enemy.vida <= 0) {
                    console.log("\nVocê derrotou o inimigo!");
                    return true;
                }
                
                console.log(`O inimigo contra-ataca causando ${enemy.qtddano} de dano!`);
                cyber.vida -= enemy.qtddano;
                
                if (cyber.vida <= 0) {
                    console.log("\nVocê foi derrotado...");
                    return false;
                }
                break;
                
            case "2":
                cyber.vida -= enemy.qtddano;
                console.log(`\nO inimigo ainda conseguiu te atacar causando ${enemy.qtddano} de dano!`);
                console.log(`\nVocê pode estar livre agora, mas não para sempre...`);
                console.log("\nVocê fugiu da batalha.");
                combatActive = false;
                return false;
                
            default:
                console.log("Opção inválida! Tente novamente.");
        }
    }
    return false;
}

async function getIdSalaCemiterio() {
    const res = await pool.query(
        'SELECT idSala FROM Sala WHERE nomeSala = $1', 
        ['Cemiterio Digital']
    );
    return res.rows[0]?.idsala;
}

async function iniciarBatalha(prompt, idCyberLutador, idInstanciaInimigo, idSala) {
    try {
        const combatants = await fetchCombatants(idCyberLutador, idInstanciaInimigo, idSala);
        const resultadoBatalha = await battleInterface(prompt, combatants.cyber, combatants.enemy);
        
        // Resetar jogador se morrer
        if (resultadoBatalha === false) {
            try {
                const idLaboratorio = await getIdSalaPadrao();
                const vidaMaxima = 10;

                if (!idLaboratorio) {
                    throw new Error('Laboratório não encontrado!');
                }

                await pool.query(`
                    UPDATE CyberLutador 
                    SET 
                        vida = $1,
                        fk_sala_atual = $2
                    WHERE idCyberLutador = $3`,
                    [vidaMaxima, idLaboratorio, idCyberLutador]
                );

                console.log("\n[SISTEMA] Você foi revivido no Laboratório com vida cheia!");
            } catch (error) {
                console.log("Erro ao resetar jogador:", error.message);
            }
        } 
        else {
            
            // Atualizar vida normal se não morreu
            await pool.query(
                'UPDATE CyberLutador SET vida = $1 WHERE idCyberLutador = $2',
                [combatants.cyber.vida, idCyberLutador]
            );
        }

        // Mover inimigo se derrotado
        if (combatants.enemy.vida <= 0) {
            try {
                const idSalaCemiterio = await getIdSalaCemiterio();
                
                if (!idSalaCemiterio) {
                    throw new Error('Cemitério Digital não encontrado!');
                }

                const moveQuery = `
                    UPDATE NPC 
                    SET fk_sala = $1 
                    WHERE idNPC = (
                        SELECT i.fk_npc 
                        FROM InstanciaInimigo ii 
                        JOIN Inimigo i ON ii.fk_inimigo = i.idInimigo 
                        WHERE ii.idInstanciaInimigo = $2
                    )`;

                const result = await pool.query(moveQuery, [idSalaCemiterio, idInstanciaInimigo]);

                console.log(result.rowCount > 0 
                    ? "Inimigo movido para o Cemitério Digital." 
                    : "Nenhum inimigo para mover.");
            } catch (error) {
                console.log("Erro ao mover inimigo:", error.message);
            }
        }

        return resultadoBatalha;
    } catch (error) {
        console.log("Erro na batalha:", error.message);
        return false;
    }
}

async function verificarEIniciarBatalha(prompt, idCyberLutador, idSala) {
    try {
        const query = `
            SELECT ii.idInstanciaInimigo 
            FROM InstanciaInimigo ii
            JOIN Inimigo i ON ii.fk_inimigo = i.idInimigo
            JOIN NPC n ON i.fk_npc = n.idNPC
            WHERE n.fk_sala = $1
            LIMIT 1;`;

        const res = await pool.query(query, [idSala]);

        if (res.rows.length > 0) {
            const idInstanciaInimigo = res.rows[0].idinstanciainimigo;
            console.log("\nUm inimigo apareceu! Prepare-se para a batalha!");
            return iniciarBatalha(prompt, idCyberLutador, idInstanciaInimigo, idSala);
        } else {
            console.log("Nenhum inimigo encontrado nesta sala.");
            return null;
        }
    } catch (error) {
        console.error("Erro ao verificar inimigo:", error.message);
        throw error;
    }
}

module.exports = {
    iniciarBatalha,
    verificarEIniciarBatalha
};