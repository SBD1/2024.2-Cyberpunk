-- Sequências
CREATE SEQUENCE IF NOT EXISTS regiao_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS sala_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS cyberlutador_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS npc_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS missao_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS puzzle_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS dialogo_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS instancia_item_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS item_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS faccao_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS mercado_clandestino_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS mochila_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS carro_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS instancia_inimigo_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS netrunners_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS codekeepers_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS implante_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS visaocibernetica_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS bracorobotico_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS capaceteneural_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS recompensa_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS recompensamissao_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS mentor_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS inimigo_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS biochip_id_seq START WITH 1 INCREMENT BY 1;

-- Tabelas básicas (sem dependências)
CREATE TABLE IF NOT EXISTS Regiao (
  idRegiao INT PRIMARY KEY DEFAULT nextval('regiao_id_seq'),
  nomeRegiao VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Sala (
  idSala INT PRIMARY KEY DEFAULT nextval('sala_id_seq'),
  nomeSala VARCHAR(50) NOT NULL,
  norte INT,
  sul INT,
  leste INT,
  oeste INT,
  fk_regiao INT NOT NULL,
  FOREIGN KEY (fk_regiao) REFERENCES Regiao (idRegiao) ON DELETE CASCADE,
  FOREIGN KEY (norte) REFERENCES Sala (idSala) ON DELETE SET NULL,
  FOREIGN KEY (sul) REFERENCES Sala (idSala) ON DELETE SET NULL,
  FOREIGN KEY (leste) REFERENCES Sala (idSala) ON DELETE SET NULL,
  FOREIGN KEY (oeste) REFERENCES Sala (idSala) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS Item (
  idItem INT PRIMARY KEY DEFAULT nextval('item_id_seq'),
  nomeItem VARCHAR(50) NOT NULL,
  descricao VARCHAR(255) NOT NULL,
  valor INT NOT NULL
);

CREATE TABLE IF NOT EXISTS CyberLutador (
  idCyberLutador INT PRIMARY KEY DEFAULT nextval('cyberlutador_id_seq'),
  nomeCyberLutador VARCHAR(50) NOT NULL,
  inteligencia INT NOT NULL,
  resistencia INT NOT NULL,
  furtividade INT NOT NULL,
  percepcao INT NOT NULL,
  vida INT NOT NULL,
  velocidade INT NOT NULL,
  forca INT NOT NULL,
  fk_sala_atual INT NOT NULL, 
  FOREIGN KEY (fk_sala_atual) REFERENCES Sala (idSala)
);

CREATE TABLE IF NOT EXISTS NPC (
  idNPC INT PRIMARY KEY DEFAULT nextval('npc_id_seq'),
  nomeNPC VARCHAR(50) NOT NULL,
  descricao VARCHAR(255) NOT NULL,
  fk_sala INT NOT NULL,
  FOREIGN KEY (fk_sala) REFERENCES Sala (idSala) ON DELETE CASCADE
);

-- Dependências de CyberLutador e NPC
CREATE TABLE IF NOT EXISTS Inimigo (
  idInimigo INT PRIMARY KEY DEFAULT nextval('inimigo_id_seq'),
  qtdDano INT NOT NULL,
  vida INT NOT NULL,
  fk_npc INT NOT NULL,
  FOREIGN KEY (fk_npc) REFERENCES NPC (idNPC) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS InstanciaInimigo (
  idInstanciaInimigo INT PRIMARY KEY DEFAULT nextval('instancia_inimigo_id_seq'),
  fk_inimigo INT NOT NULL,
  FOREIGN KEY (fk_inimigo) REFERENCES Inimigo (idInimigo) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Missao (
  idMissao INT PRIMARY KEY DEFAULT nextval('missao_id_seq'),
  nomeMissao VARCHAR(50) NOT NULL,
  objetivo VARCHAR(255) NOT NULL,
  progresso VARCHAR(50) NOT NULL,
  fk_sala INT NOT NULL,
  fk_cyberlutador INT NOT NULL,
  FOREIGN KEY (fk_sala) REFERENCES Sala (idSala) ON DELETE CASCADE, 
  FOREIGN KEY (fk_cyberlutador) REFERENCES CyberLutador (idCyberLutador) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Puzzle (
  idPuzzle INT PRIMARY KEY DEFAULT nextval('puzzle_id_seq'),
  nomePuzzle VARCHAR(30) NOT NULL,
  dificuldade VARCHAR(10) NOT NULL,
  resposta VARCHAR(50) NOT NULL,
  estado VARCHAR(50) NOT NULL,
  fk_missao INT NOT NULL,
  FOREIGN KEY (fk_missao) REFERENCES Missao (idMissao) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Dialogo (
  idDialogo INT PRIMARY KEY DEFAULT nextval('dialogo_id_seq'),
  nomeDialogo VARCHAR(255) NOT NULL,
  descricao TEXT NOT NULL,
  fk_npc INT NOT NULL,
  FOREIGN KEY (fk_npc) REFERENCES NPC (idNPC) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Faccao (
  idFaccao INT PRIMARY KEY DEFAULT nextval('faccao_id_seq'),
  fk_cyberlutador INT NOT NULL,
  nomeFaccao VARCHAR(50) NOT NULL,
  ideologia VARCHAR(255) NOT NULL,
  FOREIGN KEY (fk_cyberlutador) REFERENCES CyberLutador (idCyberLutador) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS InstanciaItem (
  idInstanciaItem INT PRIMARY KEY DEFAULT nextval('instancia_item_id_seq'),
  fk_item INT NOT NULL,
  FOREIGN KEY (fk_item) REFERENCES Item (idItem)
);

CREATE TABLE IF NOT EXISTS Mochila (
  idMochila INT PRIMARY KEY DEFAULT nextval('mochila_id_seq'),
  capacidade INT NOT NULL,
  fk_cyberlutador INT NOT NULL,
  fk_instanciaitem INT NOT NULL,
  FOREIGN KEY (fk_cyberlutador) REFERENCES CyberLutador (idCyberLutador) ON DELETE CASCADE,
  FOREIGN KEY (fk_instanciaitem) REFERENCES InstanciaItem (idInstanciaItem) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Recompensa (
  idRecompensa INT PRIMARY KEY DEFAULT nextval('recompensa_id_seq'),
  dinheiro INT NOT NULL,
  item VARCHAR(50),
  fk_instancia_inimigo INT NOT NULL,
  fk_cyberlutador INT NOT NULL,
  FOREIGN KEY (fk_instancia_inimigo) REFERENCES InstanciaInimigo (idInstanciaInimigo) ON DELETE CASCADE,
  FOREIGN KEY (fk_cyberlutador) REFERENCES CyberLutador (idCyberLutador) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS RecompensaMissao (
  idRecompensaMissao INT PRIMARY KEY DEFAULT nextval('recompensamissao_id_seq'),
  dinheiro INT NOT NULL,
  item VARCHAR(50),
  fk_sala INT NOT NULL,
  fk_cyberlutador INT NOT NULL,
  FOREIGN KEY (fk_sala) REFERENCES Sala (idSala) ON DELETE CASCADE,
  FOREIGN KEY (fk_cyberlutador) REFERENCES CyberLutador (idCyberLutador) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Mentor (
  idMentor INT PRIMARY KEY DEFAULT nextval('mentor_id_seq'),
  fk_npc INT NOT NULL,
  aumentaInteligencia INT NOT NULL,
  aumentaFurtividade INT NOT NULL,
  aumentaPercepcao INT NOT NULL,
  FOREIGN KEY (fk_npc) REFERENCES NPC (idNPC) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS NetRunners (
  idNetRunners INT PRIMARY KEY DEFAULT nextval('netrunners_id_seq'),
  fk_faccao INT NOT NULL,
  aumentaInte INT NOT NULL,
  aumentaPercep INT NOT NULL,
  FOREIGN KEY (fk_faccao) REFERENCES Faccao (idFaccao) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS CodeKeepers (
  idCodeKeepers INT PRIMARY KEY DEFAULT nextval('codekeepers_id_seq'),
  fk_faccao INT NOT NULL,
  aumentaVelo INT NOT NULL,
  aumentaResis INT NOT NULL,
  FOREIGN KEY (fk_faccao) REFERENCES Faccao (idFaccao) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS MercadoClandestino (
  idMercadoClandestino INT PRIMARY KEY DEFAULT nextval('mercado_clandestino_id_seq'),
  nomeMercado VARCHAR(50) NOT NULL,
  descricao VARCHAR(100) NOT NULL,
  fk_sala INT NOT NULL,
  FOREIGN KEY (fk_sala) REFERENCES Sala (idSala) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Mercado_Item (
  fk_mercado_clandestino INT NOT NULL,
  fk_instanciaitem INT NOT NULL,
  PRIMARY KEY (fk_mercado_clandestino, fk_instanciaitem),
  FOREIGN KEY (fk_mercado_clandestino) REFERENCES MercadoClandestino (idMercadoClandestino) ON DELETE CASCADE,
  FOREIGN KEY (fk_instanciaitem) REFERENCES InstanciaItem (idInstanciaItem) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Mochila (
  idMochila INT PRIMARY KEY DEFAULT nextval('mochila_id_seq'),
  capacidade INT NOT NULL,
  fk_cyberlutador INT NOT NULL,
  fk_instanciaitem INT NOT NULL,
  FOREIGN KEY (fk_cyberlutador) REFERENCES CyberLutador (idCyberLutador) ON DELETE CASCADE,
  FOREIGN KEY (fk_instanciaitem) REFERENCES InstanciaItem (idInstanciaItem) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Mochila_Item (
  fk_mochila INT NOT NULL,
  fk_instanciaitem INT NOT NULL,
  PRIMARY KEY (fk_mochila, fk_instanciaitem),
  FOREIGN KEY (fk_mochila) REFERENCES Mochila (idMochila) ON DELETE CASCADE,
  FOREIGN KEY (fk_instanciaitem) REFERENCES InstanciaItem (idInstanciaItem) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Carro (
  idCarro INT PRIMARY KEY DEFAULT nextval('carro_id_seq'),
  combustivel INT NOT NULL,
  fk_regiao INT NOT NULL,
  FOREIGN KEY (fk_regiao) REFERENCES Regiao (idRegiao) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Implante (
  idImplante INT PRIMARY KEY DEFAULT nextval('implante_id_seq'),
  nomeImplante VARCHAR(50) NOT NULL,
  tipo VARCHAR(50) NOT NULL,
  fk_item INT NOT NULL,
  fk_cyberlutador INT,
  FOREIGN KEY (fk_item) REFERENCES Item (idItem) ON DELETE CASCADE,
  FOREIGN KEY (fk_cyberlutador) REFERENCES CyberLutador (idCyberLutador)
);

CREATE TABLE IF NOT EXISTS Biochip (
  idBiochip INT PRIMARY KEY DEFAULT nextval('biochip_id_seq'),
  regeneraVida INT NOT NULL,
  fk_item INT NOT NULL,
  FOREIGN KEY (fk_item) REFERENCES Item (idItem) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS VisaoCibernetica (
  idVisaocibernetica INT PRIMARY KEY DEFAULT nextval('visaocibernetica_id_seq'),
  fk_implante INT NOT NULL,
  aumentaFurti INT NOT NULL,
  aumentaPercep INT NOT NULL,
  FOREIGN KEY (fk_implante) REFERENCES Implante (idImplante) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS BracoRobotico (
  idBracorobotico INT PRIMARY KEY DEFAULT nextval('bracorobotico_id_seq'),
  fk_implante INT NOT NULL,
  aumentaForca INT NOT NULL,
  aumentaVeloc INT NOT NULL,
  FOREIGN KEY (fk_implante) REFERENCES Implante (idImplante) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS CapaceteNeural (
  idCapaceteneural INT PRIMARY KEY DEFAULT nextval('capaceteneural_id_seq'),
  fk_implante INT NOT NULL,
  aumentaInt INT NOT NULL,
  aumentaResis INT NOT NULL,
  FOREIGN KEY (fk_implante) REFERENCES Implante (idImplante) ON DELETE CASCADE
);
