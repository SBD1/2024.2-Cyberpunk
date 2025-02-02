BEGIN TRANSACTION;

-- Regiões
INSERT INTO Regiao (idRegiao, nomeRegiao) 
  VALUES (1, 'Regiao Inicial');

-- Salas
INSERT INTO Sala (idSala, nomeSala, fk_regiao)
  VALUES (0, 'Sala fantasma', 1),
         (1, 'Sala Spawn', 1), 
         (2, 'Sala 2', 1),
         (3, 'Sala 3', 1),
         (4, 'Sala 4', 1), 
         (5, 'Sala 5', 1),
         (6, 'Sala 6', 1),
         (7, 'Sala 7', 1),
         (8, 'Sala 8', 1),
         (9, 'Sala 9', 1),
         (10, 'Sala 10', 1),
         (11, 'Sala 11', 1),
         (12, 'Sala 12', 1),
         (13, 'Sala 13', 1),
         (14, 'Sala 14', 1),
         (15, 'Sala 15', 1),
         (16, 'Sala 16', 1),
         (17, 'Sala 17', 1),
         (18, 'Sala 18', 1),
         (19, 'Sala 19', 1),
         (20, 'Sala 20', 1);

-- CyberLutador

INSERT INTO CyberLutador (idCyber, nomeCyber, inteligencia, resistencia, furtividade, percepcao, vida, velocidade, forca)
  VALUES (1, 'Johnys', 10, 10, 10, 10, 100, 10, 10);

-- Missões
INSERT INTO Missao (idMissao, nomeMissao, descricao, fk_sala, fk_cyberlutador)
  VALUES (1, 'Missao Inicial', 'Descricao 1', 1, 1),
         (2, 'Decodificação inicial', 'Descricao 2', 2, 1);

-- Puzzles
INSERT INTO Puzzle (idPuzzle, nomePuzzle, dificuldade, fk_missao)
VALUES 
(1, 'Puzzle Inicial', 'Facil', 1),
(2, 'Puzzle Inicial', 'Facil', 1);

    -- Subclasses
INSERT INTO Matematico (fk_puzzle, expressao)
  VALUES (1, '2 + 2 = ?');

INSERT INTO Decodificar (fk_puzzle, codigo)
  VALUES (2, '1101 0101 0001');

-- Item
INSERT INTO Item (idItem, nomeItem, descricao, valor)
VALUES 
(1, 'Item Inicial', 'Item de teste', 100),
(2, 'Visão Cibernética', 'Implante ocular avançado com HUD integrado', 5000);

ALTER TABLE CyberLutador
ADD COLUMN fk_implante INT,
ADD CONSTRAINT fk_cyberlutador_implante FOREIGN KEY (fk_implante) REFERENCES Implante(idImplante);

-- Implantes

INSERT INTO Implante (idImplante, nomeImplante, tipo, fk_item)
VALUES (1, 'Visão Cibernética Mk.IV', 'Implante', 2);

INSERT INTO VisaoCibernetica (idVisaocibernetica, fk_implante, aumentaFurti, aumentaPercep)
VALUES (1, 1, 15, 20);

INSERT INTO InstanciaItem (idInstanciaItem, fk_item)
VALUES 
(1, 1),
(2, 2);

UPDATE CyberLutador 
SET fk_implante = 1 
WHERE idCyber = 1;

-- Mochilas

INSERT INTO Mochila (idMochila, capacidade, fk_cyberlutador, fk_instanciaitem)
  VALUES (1, 50, 1, 1);

-- Faccao

INSERT INTO Faccao (idFaccao, fk_cyberlutador, nomeFaccao, ideologia)
VALUES  
(1, 1, 'NetRunners', 'Ideologia NetRunners');

INSERT INTO NetRunners (idNetRunners, fk_faccao, aumentaInte, aumentaPercep)
VALUES 
(1, 1, 10, 10);

-- MercadoClandestino

INSERT INTO MercadoClandestino (idMercadoClandestino, nomeMercado, descricao, fk_sala)
  VALUES (1, 'Mercado Inicial', 'Descricao teste', 1);

-- Carros

INSERT INTO Carro (idCarro, combustivel, fk_regiao)
  VALUES (1, 100, 1);

-- NPCs

INSERT INTO NPC (idNPC, nomeNPC, descricao, fk_sala)
VALUES
(1, 'NPC Inicial', 'Descricao npc 1 - inimigo paia', 1),
(2, 'NPC Inicial', 'Descricao npc 2 - conversinha', 2);

INSERT INTO Mentor (fk_npc, aumentaInteligencia, aumentaFurtividade, aumentaPercepcao)
  VALUES (2, 10, 10, 10);

-- Dialogos
INSERT INTO Dialogo (idDialogo, nomeDialogo, fk_npc)
VALUES 
(1, 'Obrigado por ter vindo aqui.', 2);

-- Inimigos

INSERT INTO Inimigo (idInimigo, qtdDano, vida, fk_npc)
 VALUES (1, 7, 99, 1);

INSERT INTO InstanciaInimigo (idInstanciaInimigo, fk_inimigo)
  VALUES (1, 1);

-- Recompensas

INSERT INTO Recompensa (idRecompensa, dinheiro, item, fk_instancia_inimigo, fk_cyberlutador)
  VALUES (1, 100, 'Item Recompensa Inicial', 1, 1);

INSERT INTO RecompensaMissao (idRecompensaMissao, dinheiro, item, fk_sala, fk_cyberlutador)
  VALUES (1, 100, 'Item Recompensa Missao Inicial', 1, 1);

COMMIT;
