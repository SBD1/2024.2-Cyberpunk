const { Pool } = require('pg');

const pool = new Pool({
    user: 'postgres',
    host: 'db',
    database: 'cyberbase',
    password: 'password',
    port: 5432,
});

async function fetchCombatants(idCyberLutador, idInstanciaInimigo) {
    const client = await pool.connect();
    try {
        const cyberQuery = `
            SELECT idCyber, nomeCyberLutador, vida, forca 
            FROM CyberLutador 
            WHERE idCyber = $1`;

        const enemyQuery = `
            SELECT qtdDano, vida 
            FROM Inimigo
            JOIN InstanciaInimigo ON idInimigo = fk_inimigo
            WHERE idInstanciaInimigo = $1`;

        const [cyberResult, enemyResult] = await Promise.all([
            client.query(cyberQuery, [idCyberLutador]),
            client.query(enemyQuery, [idInstanciaInimigo])
        ]);

        if (!cyberResult.rows[0]) throw new Error('CyberLutador não encontrado');
        if (!enemyResult.rows[0]) throw new Error('Inimigo não encontrado');

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
                console.log("\nVocê fugiu da batalha!");
                combatActive = false;
                return false;
                
            default:
                console.log("Opção inválida! Tente novamente.");
        }
    }
    return false;
}

module.exports = {
    iniciarBatalha: async (prompt, idCyberLutador, idInstanciaInimigo) => {
        try {
            const combatants = await fetchCombatants(idCyberLutador, idInstanciaInimigo);
            return battleInterface(prompt, combatants.cyber, combatants.enemy);
        } catch (error) {
            console.log("Erro na batalha:", error.message);
            return false;
        }
    }
};
