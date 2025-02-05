-- Adicionando NPCs
INSERT INTO NPC (nomeNPC, descricao, fk_sala)
SELECT 'Dr. Cipher', 'Um cientista excêntrico obcecado por criptografia.', 
       (SELECT idSala FROM Sala WHERE nomeSala = 'Laboratorio' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM NPC WHERE nomeNPC = 'Dr. Cipher');

INSERT INTO NPC (nomeNPC, descricao, fk_sala)
SELECT 'Shade', 'Um mercenário digital que vende informações valiosas.', 
       (SELECT idSala FROM Sala WHERE nomeSala = 'Beco Data Stream' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM NPC WHERE nomeNPC = 'Shade');

INSERT INTO NPC (nomeNPC, descricao, fk_sala)
SELECT 'Neon', 'Dona do SkyBar Holográfico, sempre sabe de tudo o que acontece.', 
       (SELECT idSala FROM Sala WHERE nomeSala = 'SkyBar Holográfico' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM NPC WHERE nomeNPC = 'Neon');


-- Adicionando diálogos para os NPCs
INSERT INTO Dialogo (fk_npc, nomeDialogo, descricao)
SELECT 
    (SELECT idNPC FROM NPC WHERE nomeNPC = 'Dr. Cipher' LIMIT 1), 
    'Então, você quer respostas?', 
    'O mundo que conhecemos já foi desmontado e remontado tantas vezes que ninguém mais se lembra da versão original. O que chamamos de realidade é só um conjunto de dados manipuláveis. Se deseja sobreviver aqui, precisa entender uma coisa: o corpo é um hardware frágil, mas a mente... ah, a mente pode ser atualizada. Eu posso te dar mais do que olhos que enxergam no escuro. Posso te dar visão para ver a verdade por trás das ilusões. A questão é: você tem medo de mudar?'
WHERE NOT EXISTS (
    SELECT 1 FROM Dialogo 
    WHERE fk_npc = (SELECT idNPC FROM NPC WHERE nomeNPC = 'Dr. Cipher' LIMIT 1) 
    AND nomeDialogo = 'Então, você quer respostas?'
);


INSERT INTO Dialogo (fk_npc, nomeDialogo, descricao)
SELECT 
    (SELECT idNPC FROM NPC WHERE nomeNPC = 'Shade' LIMIT 1), 
    'A informação não é só poder, é a única moeda que realmente importa.', 
    'Ah, vejo que você tá faminto por respostas... bem, a fome se paga. E aqui, a moeda é informação. O que quer saber? Quem controla o Distrito 7? Como hackear o sistema de créditos corporativo? Ou talvez… como desaparecer sem deixar rastros? Eu sei tudo isso. Mas nada vem de graça, parceiro. Neste mundo, ou você compra a verdade ou vende uma mentira. A escolha é sua.'
WHERE NOT EXISTS (
    SELECT 1 FROM Dialogo 
    WHERE fk_npc = (SELECT idNPC FROM NPC WHERE nomeNPC = 'Shade' LIMIT 1) 
    AND nomeDialogo = 'A informação não é só poder, é a única moeda que realmente importa.'
);

INSERT INTO Dialogo (fk_npc, nomeDialogo, descricao)
SELECT 
    (SELECT idNPC FROM NPC WHERE nomeNPC = 'Neon' LIMIT 1), 
    'Bem-vindo ao SkyBar. Aqui, um brinde pode valer mais que ouro.', 
    'Sabe o que eu mais gosto nesse lugar? As histórias. Todos os dias, gente de todas as camadas da cidade vem aqui, pedindo uma bebida e despejando segredos. Os ricos querem se sentir vivos, os rebeldes querem se esquecer da realidade, e os solitários… bom, esses só querem ser ouvidos. O que você procura, forasteiro? Um drink, um conselho ou talvez... um destino? Seja o que for, lembre-se: neste mundo, todo gole tem um preço, e algumas verdades são amargas demais para engolir.'

WHERE NOT EXISTS (
    SELECT 1 FROM Dialogo 
    WHERE fk_npc = (SELECT idNPC FROM NPC WHERE nomeNPC = 'Neon' LIMIT 1) 
    AND nomeDialogo = 'Bem-vindo ao SkyBar. Aqui, um brinde pode valer mais que ouro.'
);


--- Adicionando Npcs como mentores ------
INSERT INTO Mentor (fk_npc, aumentaInteligencia, aumentaFurtividade, aumentaPercepcao)
SELECT idNPC, 2, 1, 1
FROM NPC 
WHERE nomeNPC = 'Dr. Cipher'
AND NOT EXISTS (SELECT 1 FROM Mentor WHERE fk_npc = (SELECT idNPC FROM NPC WHERE nomeNPC = 'Dr. Cipher'));

INSERT INTO Mentor (fk_npc, aumentaInteligencia, aumentaFurtividade, aumentaPercepcao)
SELECT idNPC, 1, 2, 1
FROM NPC 
WHERE nomeNPC = 'Shade'
AND NOT EXISTS (SELECT 1 FROM Mentor WHERE fk_npc = (SELECT idNPC FROM NPC WHERE nomeNPC = 'Shade'));

INSERT INTO Mentor (fk_npc, aumentaInteligencia, aumentaFurtividade, aumentaPercepcao)
SELECT idNPC, 1, 1, 2 
FROM NPC 
WHERE nomeNPC = 'Neon'
AND NOT EXISTS (SELECT 1 FROM Mentor WHERE fk_npc = (SELECT idNPC FROM NPC WHERE nomeNPC = 'Neon'));
