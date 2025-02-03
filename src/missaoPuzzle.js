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
  
    return { dica: 'Cada letra do alfabeto corresponde a um número.\n', palavraCodificada, resposta: palavraEscolhida };
  }
  
  async function iniciarMissao(cyberLutador, pool) {
    console.log("\n    ========================= Você iniciou uma missão! ============================");
  
    const historiaMissao = 
    `\n    Você foi convocado para uma missão crítica. Um sistema de inteligência artificial,
    projetado para controlar as cidades cibernéticas, foi hackeado por uma facção desconhecida.
    Seu objetivo é recuperar o controle do sistema resolvendo puzzles complexos.
  
    Cada passo certo aproxima você do sucesso. Boa sorte, CyberLutador!\n`;
    console.log(historiaMissao);
  
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
  
    const respostaJogador = prompt("Digite sua resposta: ");
    if (respostaJogador.toLowerCase() === String(puzzle.resposta).toLowerCase()) {
        console.log("\nParabéns! Você resolveu o puzzle.");
    } else {
        console.log("\nResposta incorreta.");
    }
  }
  
  module.exports = {
    gerarPuzzleMatematico,
    gerarPuzzleDecodificador,
    iniciarMissao
  };