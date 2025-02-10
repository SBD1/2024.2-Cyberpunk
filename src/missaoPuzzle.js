const { Pool } = require('pg');
const prompt = require('prompt-sync')();

function gerarPuzzleMatematico() {
    const num1 = Math.floor(Math.random() * 500) + 100;
    const num2 = Math.floor(Math.random() * 500) + 100;
    const operacoes = ['+', '-', '*', '/'];
    const operacao = operacoes[Math.floor(Math.random() * operacoes.length)];
    let resultado;

    switch (operacao) {
        case '+': resultado = num1 + num2; break;
        case '-': resultado = num1 - num2; break;
        case '*': resultado = num1 * num2; break;
        case '/': resultado = Math.floor(num1 / num2); break;
    }

    return { pergunta: `Resolva: ${num1} ${operacao} ${num2}\n`, resposta: resultado };
}

function gerarPuzzleDecodificador() {
    const palavrasCyberpunk = ['neon', 'hacker', 'android', 'implante', 'circuito', 'ciborgue', 'edgerunner'];
    const palavraEscolhida = palavrasCyberpunk[Math.floor(Math.random() * palavrasCyberpunk.length)];

    const alfabeto = 'abcdefghijklmnopqrstuvwxyz';
    const mapeamento = {};
    let numero = 1;

    for (const letra of alfabeto) {
        mapeamento[letra] = numero;
        numero++;
    }

    let palavraCodificada = '';
    for (const letra of palavraEscolhida) {
        palavraCodificada += mapeamento[letra] + ' ';
    }

    return { dica: '\nCada letra do alfabeto corresponde a um número.\n', palavraCodificada, resposta: palavraEscolhida };
}

async function salvarProgressoMissao(pool, idMissao, progresso) {
    const query = `
        UPDATE Missao
        SET progresso = $1
        WHERE idMissao = $2;
    `;
    await pool.query(query, [progresso, idMissao]);
}

async function carregarProgressoMissao(pool, idMissao) {
    const query = `
        SELECT progresso FROM Missao
        WHERE idMissao = $1;
    `;
    const res = await pool.query(query, [idMissao]);
    return res.rows[0] ? res.rows[0].progresso : null;
}

async function verificarMissaoConcluida(pool, idCyberLutador) {
    const query = `
        SELECT COUNT(DISTINCT fk_sala) AS totalConcluidas FROM Missao
        WHERE fk_cyberlutador = $1 AND progresso = 'Concluída'
        AND nomeMissao IN ('Missão Principal', 'Missão Secundária', 'Missão Terciária');
    `;
    const res = await pool.query(query, [idCyberLutador]);
    return res.rows[0].totalconcluidas; // Retorna o número de missões principais concluídas em salas diferentes
}

async function aplicarRecompensa(pool, idCyberLutador) {
    const query = `
        UPDATE Mochila
        SET dinheiro = dinheiro + 50
        WHERE fk_cyberlutador = $1;
    `;
    await pool.query(query, [idCyberLutador]);
    console.log("\nVocê recebeu 50 unidades de dinheiro como recompensa!");
}

async function iniciarMissao(cyberLutador, pool, idMissao) {
    console.log("\n    ========================= Você iniciou uma missão! ============================");

    const historiaMissao =
        `\n    Você foi convocado para uma missão crítica. Um sistema de inteligência artificial, projetado para controlar 
    as cidades cibernéticas, foi hackeado por uma facção desconhecida. Se não for restaurado a tempo, o caos tomará conta das ruas digitais.

    Para recuperar o controle, você deve completar 3 missões, cada uma localizada em uma sala diferente. 
    
    Cada sala contém um puzzle desafiador que testa sua lógica e habilidade.

    Cada passo certo aproxima você do sucesso. Boa sorte, CyberLutador!\n`;
    console.log(historiaMissao);

    const totalPuzzlesNecessarios = 5; 
    let puzzlesResolvidos = 0;

    const progresso = await carregarProgressoMissao(pool, idMissao);
    if (progresso && progresso !== 'Concluída') {
        puzzlesResolvidos = parseInt(progresso.split('/')[0], 10);
        console.log(`\nVocê está continuando a missão de onde parou. Progresso atual: ${progresso}`);
    }

    while (puzzlesResolvidos < totalPuzzlesNecessarios) {
        const tipoPuzzle = Math.random() > 0.5 ? 'matematica' : 'decodificador';
        let puzzle;

        if (tipoPuzzle === 'matematica') {
            puzzle = gerarPuzzleMatematico();
            console.log(puzzle.pergunta);
        } else {
            puzzle = gerarPuzzleDecodificador();
            console.log(puzzle.dica);
            console.log(`Palavra codificada: ${puzzle.palavraCodificada}\n`);
        }

        const respostaJogador = prompt("Digite sua resposta (ou 'sair' para sair da missão): ");
        if (respostaJogador.toLowerCase() === 'sair') {
            console.log("\nVocê escolheu sair da missão. Progresso salvo.");
            await salvarProgressoMissao(pool, idMissao, `${puzzlesResolvidos}/${totalPuzzlesNecessarios}`);
            return;
        }

        if (respostaJogador.toLowerCase() === String(puzzle.resposta).toLowerCase()) {
            puzzlesResolvidos++;
            const progresso = (puzzlesResolvidos / totalPuzzlesNecessarios) * 100;
            console.log("\nParabéns! Você resolveu o puzzle.");
            console.log(`Progresso da missão: ${progresso.toFixed(2)}%`);
        } else {
            console.log("\nResposta incorreta. Tente novamente.");
        }
    }

    console.log("\nParabéns! Você concluiu a missão!");
    await salvarProgressoMissao(pool, idMissao, 'Concluída');

    // Aplicar recompensa ao completar a missão
    await aplicarRecompensa(pool, cyberLutador.id);

    // Verificar se o jogador completou 3 missões em salas diferentes
    const totalMissõesConcluidas = await verificarMissaoConcluida(pool, cyberLutador.id);
    console.log(`Total de missões concluídas: ${totalMissõesConcluidas}`); // Debug: Mostrar o total de missões principais concluídas

    if (totalMissõesConcluidas === 3) {
        console.log("\nParabéns! Você concluiu todas as 3 missões principais e salvou o mundo cibernético!");
        console.log("Fim do jogo.");
        process.exit(0); // Encerra o jogo
    }
}

module.exports = {
    gerarPuzzleMatematico,
    gerarPuzzleDecodificador,
    iniciarMissao,
    carregarProgressoMissao,
    verificarMissaoConcluida
};