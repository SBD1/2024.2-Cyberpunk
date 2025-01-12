  -- Arquivo: ddl/insert_data.sql

  -- Exemplo
  -- INSERT INTO users (name, email) VALUES ('John Doe', 'john.doe@example.com');
  -- INSERT INTO users (name, email) VALUES ('Alice Wonderland', 'alice.wonderland@example.com');

-- Regiões
INSERT INTO Regiao (idRegiao, nomeRegiao, fk_mapa) 
  VALUES (1, 'Regiao Inicial', 1);

-- Salas
INSERT INTO Sala (idSala, nomeSala, fk_regiao)
  VALUES (1, 'Sala Spawn', 1), 
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

-- ExoHumanos
INSERT INTO ExoHumano (idExoHumano, nome, fk_sala)
  VALUES (1,'ExoHumano Inicial', 1);

-- Missões
INSERT INTO Missao (idMissao, nomeMissao, recompensa, itensNecessario, objetivo, fk_sala, fk_exohumano)
  VALUES (1, 'Missao Inicial', 100, NULL, 'Resultado da soma', 1, 1),
         (2, 'Decodificação inicial', 100, NULL, 'Digitar "hello world"', 2, 1);

-- Puzzles
INSERT INTO Puzzle (idPuzzlle, nomePuzzle, dificuldade, fk_missao)
  VALUES (1, 'Puzzle Inicial', 'Facil', 1);

-- Subclasses
INSERT INTO Matematico (fk_puzzle, expressao)
  VALUES (1, '2 + 2 = ?');

INSERT INTO Decodificar (fk_puzzle, codigo)
  VALUES (2, 'A = 1, B = 2, C = 3, D = 4, E = 5, F = 6, G = 7, H = 8, I = 9, J = 10, K = 11, L = 12, M = 13, N = 14, O = 15, P = 16, Q = 17, R = 18, S = 19, T = 20, U = 21, V = 22, W = 23, X = 24, Y = 25, Z = 26');

-- Dialogos
INSERT INTO Dialogo (idDialogo, nomeDialogo, fk_exohumano)
  VALUES ('Olá, bem vindo ao jogo!', 1),
         ('Você está na sala 1', 1),
         ('Você está na sala 2', 2),
         ('Você está na sala 3', 3),
         ('Você está na sala 4', 4),
         ('Você está na sala 5', 5),
         ('Você está na sala 6', 6),
         ('Você está na sala 7', 7),
         ('Você está na sala 8', 8),
         ('Você está na sala 9', 9),
         ('Você está na sala 10', 10),
         ('Você está na sala 11', 11),
         ('Você está na sala 12', 12),
         ('Você está na sala 13', 13),
         ('Você está na sala 14', 14),
         ('Você está na sala 15', 15),
         ('Você está na sala 16', 16),
         ('Você está na sala 17', 17),
         ('Você está na sala 18', 18),
         ('Você está na sala 19', 19),
         ('Você está na sala 20', 20);

-- CyberLutador

INSERT INTO CyberLutador (idCyberLutador, inteligencia, resistencia, furtividade, percepcao, vida, velocidade, fk_player, fk_inimigo)
  VALUES (1, 10, 10, 10, 10, 100, 10, player, inimigo);

UPDATE CyberLutador
  SET inteligencia = inteligencia + num,
      resistencia = resistencia + num,
      furtividade = furtividade + num,
      percepcao = percepcao + num,
      vida = vida + num,
      velocidade = velocidade + num
  WHERE idCyberLutador = 1;

-- Item
INSERT INTO Item (idItem, nomeItem, descricao, valor)
  VALUES (1, 'Item Inicial', 'Item de teste', 100);


INSERT INTO InstanciaItem (idInstanciaItem, fk_item)
  VALUES (1, 1);

DELETE FROM InstanciaItem
  WHERE idInstanciaItem = 1;

-- NPCs

INSERT INTO NPC (idNPC, nomeNPC, fk_sala)
  VALUES (1, 'NPC Inicial', 1);

-- Componentes

INSERT INTO Componente (idComponente, nomeComponente, tipo)
  VALUES (1, 'Componente Inicial', 'bracoRobotico');

-- Faccao

INSERT INTO Faccao (idFaccao, nomeFaccao, ideologia, tecnologia, territorio, forcaMilitar, especialidade)
  VALUES (1, 'Faccao Inicial', 'Ideologia de teste', 'Tecnologia de teste', 'Territorio de teste', 100, 'Especialidade de teste'),
         (2, 'NetRunners', 'Ideologia NetRunners', 'Tecnologia NetRunners', 'Territorio NetRunners', 100, 'Especialidade NetRunners'),
         (3, 'CodeKeepers', 'Ideologia CodeKeepers', 'Tecnologia CodeKeepers', 'Territorio CodeKeepers', 100, 'Especialidade CodeKeepers'),
         (4, 'VoidWalkers', 'Ideologia VoidWalkers', 'Tecnologia VoidWalkers', 'Territorio VoidWalkers', 100, 'Especialidade VoidWalkers');


-- MercadoClandestino

INSERT INTO MercadoClandestino (idMercadoClandestino, nomeMercado, produtoFornecido, fk_sala)
  VALUES (1, 'Mercado Inicial', 'Produto de teste', 1);

-- Mochilas

INSERT INTO Mochila (idMochila, capacidade, fk_player, fk_item)
  VALUES (1, 50, 1, 1);

-- Carros

INSERT INTO Carro (idCarro, capacidade, velocidade, combustivel, preco, conservacao, nivelSeguranca, blindagem, fk_regiao, fk_mercado_clandestino)
  VALUES (1, 50, 100, 100, 100, 100, 100, 100, 1, 1);

-- Player 

INSERT INTO Player (idPlayer, inteligencia, resistencia, furtividade, percepcao, vida, velocidade, fk_cyberLutador)
  VALUES (1, 10, 10, 10, 10, 100, 10, 1);

-- Inimigos

INSERT INTO Inimigo (idInimigo, inteligencia, resistencia, furtividade, percepcao, vida, velocidade, fk_cyberLutador)
  VALUES (1, 10, 10, 10, 10, 100, 10, 1);


INSERT INTO InstanciaInimigo (idInstanciaInimigo, fk_inimigo, fk_player)
  VALUES (1, 1, 1);

UPDATE InstanciaInimigo
  SET inteligencia = inteligencia + num,
      resistencia = resistencia + num,
      furtividade = furtividade + num,
      percepcao = percepcao + num,
      vida = vida + num,
      velocidade = velocidade + num
  WHERE idInstanciaInimigo = 1;

DELETE InstanciaInimigo
  WHERE idInstanciaInimigo = 1;


-- Implantes

INSERT INTO Implante (idImplante, nomeImplante, tipo, localInstalacao, upgrade, fk_cyberLutador)
  VALUES (1, 'Implante Inicial', 'Implante de teste', 'Local de teste', 1, 1);

INSERT INTO VisaoCibernetica (fk_implante, aumentaFurtividade, aumentaPercepcao)
  VALUES (1, 10, 10);

INSERT INTO BracoRobotico (fk_implante, aumentaVida, aumentaResistencia)
  VALUES (1, 10, 10);

INSERT INTO CapaceteNeural (fk_implante, aumentaVelocidade, aumentaInteligencia)
  VALUES (1, 10, 10);