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

-- 1. Insere um NPC que será usado como inimigo
INSERT INTO NPC (nomeNPC, descricao, fk_sala)
VALUES (
  'Inimigo Básico',
  'Um inimigo criado para batalhas simples.',
  (SELECT idSala FROM Sala WHERE nomeSala = 'Laboratorio' LIMIT 1)
);

-- 2. Insere um registro na tabela Inimigo associando-o ao NPC criado
INSERT INTO Inimigo (qtdDano, vida, fk_npc)
VALUES (
  1,    -- quantidade de dano que o inimigo causará
  3,    -- pontos de vida do inimigo
  (SELECT idNPC FROM NPC WHERE nomeNPC = 'Inimigo Básico' LIMIT 1)
);

-- 3. Insere uma instância deste inimigo para que ele possa ser enfrentado na batalha
INSERT INTO InstanciaInimigo (fk_inimigo)
VALUES (
  (SELECT idInimigo FROM Inimigo WHERE fk_npc = (SELECT idNPC FROM NPC WHERE nomeNPC = 'Inimigo Básico' LIMIT 1) LIMIT 1)
);
----------------------------------------------------------
-- Inimigo 1: Glitch Berserker (Ruínas Cibernéticas)
----------------------------------------------------------
INSERT INTO NPC (nomeNPC, descricao, fk_sala)
SELECT 'Glitch Berserker', 'Humanoide digital com membros distorcidos emitindo pulsos eletromagnéticos.', 
       (SELECT idSala FROM Sala WHERE nomeSala = 'Ruinas Ciberneticas' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM NPC WHERE nomeNPC = 'Glitch Berserker');

INSERT INTO Inimigo (qtdDano, vida, fk_npc)
SELECT 1, 5, idNPC 
FROM NPC 
WHERE nomeNPC = 'Glitch Berserker'
LIMIT 1;

INSERT INTO InstanciaInimigo (fk_inimigo)
SELECT idInimigo 
FROM Inimigo 
WHERE fk_npc = (SELECT idNPC FROM NPC WHERE nomeNPC = 'Glitch Berserker' LIMIT 1);

----------------------------------------------------------
-- Inimigo 2: Phantom Hacker (Submundo Hacker)
----------------------------------------------------------
INSERT INTO NPC (nomeNPC, descricao, fk_sala)
SELECT 'Phantom Hacker', 'Fantasma digital que corrompe sistemas de defesa.', 
       (SELECT idSala FROM Sala WHERE nomeSala = 'Submundo Hacker' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM NPC WHERE nomeNPC = 'Phantom Hacker');

INSERT INTO Inimigo (qtdDano, vida, fk_npc)
SELECT 1, 5, idNPC 
FROM NPC 
WHERE nomeNPC = 'Phantom Hacker'
LIMIT 1;

INSERT INTO InstanciaInimigo (fk_inimigo)
SELECT idInimigo 
FROM Inimigo 
WHERE fk_npc = (SELECT idNPC FROM NPC WHERE nomeNPC = 'Phantom Hacker' LIMIT 1);

----------------------------------------------------------
-- Inimigo 3: Drone Sentinel (Beco Data Stream)
----------------------------------------------------------
INSERT INTO NPC (nomeNPC, descricao, fk_sala)
SELECT 'Drone Sentinel', 'Drone de combate com armadura reforçada e canhões plasma.', 
       (SELECT idSala FROM Sala WHERE nomeSala = 'Beco Data Stream' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM NPC WHERE nomeNPC = 'Drone Sentinel');

INSERT INTO Inimigo (qtdDano, vida, fk_npc)
SELECT 1, 5, idNPC 
FROM NPC 
WHERE nomeNPC = 'Drone Sentinel'
LIMIT 1;

INSERT INTO InstanciaInimigo (fk_inimigo)
SELECT idInimigo 
FROM Inimigo 
WHERE fk_npc = (SELECT idNPC FROM NPC WHERE nomeNPC = 'Drone Sentinel' LIMIT 1);

----------------------------------------------------------
-- Inimigo 4: Crypt Guardian (Templo Cibernético)
----------------------------------------------------------
INSERT INTO NPC (nomeNPC, descricao, fk_sala)
SELECT 'Crypt Guardian', 'Guardião ancestral de dados criptografados com escudo energético.', 
       (SELECT idSala FROM Sala WHERE nomeSala = 'Templo Cibernético' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM NPC WHERE nomeNPC = 'Crypt Guardian');

INSERT INTO Inimigo (qtdDano, vida, fk_npc)
SELECT 1, 5, idNPC 
FROM NPC 
WHERE nomeNPC = 'Crypt Guardian'
LIMIT 1;

INSERT INTO InstanciaInimigo (fk_inimigo)
SELECT idInimigo 
FROM Inimigo 
WHERE fk_npc = (SELECT idNPC FROM NPC WHERE nomeNPC = 'Crypt Guardian' LIMIT 1);

----------------------------------------------------------
-- Inimigo 5: Rogue AI (Terminal Nexus Desativado)
----------------------------------------------------------
INSERT INTO NPC (nomeNPC, descricao, fk_sala)
SELECT 'Rogue AI', 'Inteligência artificial defeituosa que ataca qualquer intruso.', 
       (SELECT idSala FROM Sala WHERE nomeSala = 'Terminal Nexus Desativado' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM NPC WHERE nomeNPC = 'Rogue AI');

INSERT INTO Inimigo (qtdDano, vida, fk_npc)
SELECT 1, 5, idNPC 
FROM NPC 
WHERE nomeNPC = 'Rogue AI'
LIMIT 1;

INSERT INTO InstanciaInimigo (fk_inimigo)
SELECT idInimigo 
FROM Inimigo 
WHERE fk_npc = (SELECT idNPC FROM NPC WHERE nomeNPC = 'Rogue AI' LIMIT 1);

----------------------------------------------------------
-- Inimigo 6: Firewall Entity (Refúgio Rebelde)
----------------------------------------------------------
INSERT INTO NPC (nomeNPC, descricao, fk_sala)
SELECT 'Firewall Entity', 'Manifestação digital de um firewall de segurança.', 
       (SELECT idSala FROM Sala WHERE nomeSala = 'Refúgio Rebelde' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM NPC WHERE nomeNPC = 'Firewall Entity');

INSERT INTO Inimigo (qtdDano, vida, fk_npc)
SELECT 1, 5, idNPC 
FROM NPC 
WHERE nomeNPC = 'Firewall Entity'
LIMIT 1;

INSERT INTO InstanciaInimigo (fk_inimigo)
SELECT idInimigo 
FROM Inimigo 
WHERE fk_npc = (SELECT idNPC FROM NPC WHERE nomeNPC = 'Firewall Entity' LIMIT 1);
----------------------------------------------------------
-- Inimigo 7: Neon Marauder (Distrito Neon)
----------------------------------------------------------
INSERT INTO NPC (nomeNPC, descricao, fk_sala)
SELECT 'Neon Marauder', 'Bandido cibernético que se camufla nos sinais luminosos do distrito.', 
       (SELECT idSala FROM Sala WHERE nomeSala = 'Distrito Neon' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM NPC WHERE nomeNPC = 'Neon Marauder');

INSERT INTO Inimigo (qtdDano, vida, fk_npc)
SELECT 1, 5, idNPC 
FROM NPC 
WHERE nomeNPC = 'Neon Marauder'
LIMIT 1;

INSERT INTO InstanciaInimigo (fk_inimigo)
SELECT idInimigo 
FROM Inimigo 
WHERE fk_npc = (SELECT idNPC FROM NPC WHERE nomeNPC = 'Neon Marauder' LIMIT 1);

----------------------------------------------------------
-- Inimigo 8: Market Crawler (Arranha-céu Digital)
----------------------------------------------------------
INSERT INTO NPC (nomeNPC, descricao, fk_sala)
SELECT 'Market Crawler', 'Entidade parasita que se alimenta de dados de transações ilegais.', 
       (SELECT idSala FROM Sala WHERE nomeSala = 'Arranha-céu Digital' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM NPC WHERE nomeNPC = 'Market Crawler');

INSERT INTO Inimigo (qtdDano, vida, fk_npc)
SELECT 1, 5, idNPC 
FROM NPC 
WHERE nomeNPC = 'Market Crawler'
LIMIT 1;

INSERT INTO InstanciaInimigo (fk_inimigo)
SELECT idInimigo 
FROM Inimigo 
WHERE fk_npc = (SELECT idNPC FROM NPC WHERE nomeNPC = 'Market Crawler' LIMIT 1);

----------------------------------------------------------
-- Inimigo 9: Cipher Warden (Camara de Criptografia)
----------------------------------------------------------
INSERT INTO NPC (nomeNPC, descricao, fk_sala)
SELECT 'Cipher Warden', 'Guardião automatizado que patrulha códigos criptografados.', 
       (SELECT idSala FROM Sala WHERE nomeSala = 'Camara de Criptografia' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM NPC WHERE nomeNPC = 'Cipher Warden');

INSERT INTO Inimigo (qtdDano, vida, fk_npc)
SELECT 1, 5, idNPC 
FROM NPC 
WHERE nomeNPC = 'Cipher Warden'
LIMIT 1;

INSERT INTO InstanciaInimigo (fk_inimigo)
SELECT idInimigo 
FROM Inimigo 
WHERE fk_npc = (SELECT idNPC FROM NPC WHERE nomeNPC = 'Cipher Warden' LIMIT 1);

----------------------------------------------------------
-- Inimigo 10: Fortress Golem (Fortaleza Virtual)
----------------------------------------------------------
INSERT INTO NPC (nomeNPC, descricao, fk_sala)
SELECT 'Fortress Golem', 'Constructo digital programado para eliminar invasores.', 
       (SELECT idSala FROM Sala WHERE nomeSala = 'Fortaleza Virtual' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM NPC WHERE nomeNPC = 'Fortress Golem');

INSERT INTO Inimigo (qtdDano, vida, fk_npc)
SELECT 1, 5, idNPC 
FROM NPC 
WHERE nomeNPC = 'Fortress Golem'
LIMIT 1;

INSERT INTO InstanciaInimigo (fk_inimigo)
SELECT idInimigo 
FROM Inimigo 
WHERE fk_npc = (SELECT idNPC FROM NPC WHERE nomeNPC = 'Fortress Golem' LIMIT 1);
