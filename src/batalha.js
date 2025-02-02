const { Pool } = require('pg');

// Configuração do pool de conexões
const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'cyberbase',
    password: 'password',
    port: 5437,
});

async function fetchCombatants() {
    console.log("1. Iniciando fetchCombatants..."); // Passo 1
    const client = await pool.connect();
    try {
        console.log("2. Conexão com o banco de dados estabelecida."); // Passo 2
        
        // Busca dados do CyberLutador
        const cyberQuery = `
            SELECT idCyber, nomeCyber, vida, forca 
            FROM CyberLutador 
            WHERE idCyber = 1`;
        console.log("3. Consulta CyberLutador preparada: ", cyberQuery); // Passo 3
        
        // Busca dados do Inimigo corrigindo o JOIN
        const enemyQuery = `
            SELECT qtdDano, vida 
            FROM Inimigo
            JOIN InstanciaInimigo ON idInimigo = fk_inimigo
            WHERE idInstanciaInimigo = 1`;
        console.log("4. Consulta Inimigo preparada: ", enemyQuery); // Passo 4

        const [cyberResult, enemyResult] = await Promise.all([
            client.query(cyberQuery),
            client.query(enemyQuery)
        ]);
        console.log("5. Consultas executadas com sucesso."); // Passo 5

        if (!cyberResult.rows[0]) throw new Error('CyberLutador não encontrado');
        if (!enemyResult.rows[0]) throw new Error('Inimigo não encontrado');
        console.log("6. Dados do CyberLutador e Inimigo encontrados."); // Passo 6

        return {
            cyber: cyberResult.rows[0],
            enemy: enemyResult.rows[0]
        };
    } catch (error) {
        console.log("Erro ao buscar combatentes:", error.message); 
        throw error; 
    } finally {
        client.release();
        console.log("7. Conexão com o banco de dados liberada."); // Passo 7
    }
}

async function battleInterface(prompt, cyber, enemy) {
    console.log("\n8. Iniciando interface de batalha..."); // Passo 8
    console.log(`\n=== BATALHA: ${cyber.nomecyber} vs Inimigo ===`);
    
    let combatActive = true;
    
    while (combatActive && cyber.vida > 0 && enemy.vida > 0) {
        console.log(`\n9. Sua vida: ${cyber.vida} | Vida do inimigo: ${enemy.vida}`); // Passo 9
        console.log("10. 1. Atacar");
        console.log("10. 2. Fugir");
        const choice = prompt("Escolha uma ação: ");

        switch(choice) {
            case "1":
                console.log("11. Jogador escolheu atacar!"); // Passo 11
                // Ataque do jogador
                console.log(`\nVocê ataca causando ${cyber.forca} de dano!`);
                enemy.vida -= cyber.forca;
                
                if (enemy.vida <= 0) {
                    console.log("\n12. Você derrotou o inimigo!"); // Passo 12

                    const client = await pool.connect();
                    try {
                        const salaFantasma = `
                            UPDATE InstanciaInimigo
                            SET fk_sala = 0
                            WHERE idInstanciaInimigo = 1 AND Inimigo.fk_npc = 1 AND npc.idnpc = 1`;
                        
                        await client.query(salaFantasma, [enemy.idInstanciaInimigo]);
                        console.log("Inimigo movido para a sala fantasma.");
                    } catch (error) {
                        console.log("Erro ao mover o inimigo para a sala fantasma:", error.message);
                    } finally {
                        client.release();
                    }

                    return true;
                }
                
                // Ataque do inimigo
                console.log(`13. O inimigo contra-ataca causando ${enemy.qtddano} de dano!`); // Passo 13
                cyber.vida -= enemy.qtddano;
                
                if (cyber.vida <= 0) {
                    console.log("\n14. Você foi derrotado..."); // Passo 14
                    return false;
                }
                break;
                
            case "2":
                console.log("\n15. Você fugiu da batalha!"); // Passo 15
                combatActive = false;
                return false;
                
            default:
                console.log("16. Opção inválida! Tente novamente."); // Passo 16
        }
    }
    return false;
}

module.exports = {
    iniciarBatalha: async (prompt) => {
        try {
            console.log("17. Iniciando batalha..."); // Passo 17
            const combatants = await fetchCombatants();
            return battleInterface(prompt, combatants.cyber, combatants.enemy);
        } catch (error) {
            console.log("18. Erro na batalha:", error.message); // Passo 18
            return false;
        }
    }
};
