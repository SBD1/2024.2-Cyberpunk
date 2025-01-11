-- Criando as sequências primeiro
CREATE SEQUENCE IF NOT EXISTS mapa_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS regiao_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS sala_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS exohumano_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS missao_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS puzzle_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS dialogo_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS cyberlutador_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS instancia_item_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS item_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS npc_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS componente_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS faccao_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS mercado_clandestino_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS mochila_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS carro_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS player_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS inimigo_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS instancia_inimigo_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS netrunners_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS codekeepers_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS voidwalkers_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS implante_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS visaocibernetica START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS bracorobotico START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS capaceteneural START WITH 1 INCREMENT BY 1;

-- Agora criando as tabelas que dependem das sequências
CREATE TABLE IF NOT EXISTS Mapa(
  idMapa INT PRIMARY KEY DEFAULT nextval('mapa_id_seq'),
  nomeMapa VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Regiao(
  idRegiao INT PRIMARY KEY DEFAULT nextval('regiao_id_seq'),
  nomeRegiao VARCHAR(50) NOT NULL,
  fk_mapa INT NOT NULL,
  FOREIGN KEY (fk_mapa) REFERENCES Mapa (idMapa)
);

CREATE TABLE IF NOT EXISTS Sala(
  idSala INT PRIMARY KEY DEFAULT nextval('sala_id_seq'),
  nomeSala VARCHAR(50) NOT NULL,
  fk_regiao INT NOT NULL,
  FOREIGN KEY (fk_regiao) REFERENCES Regiao (idRegiao)
);

CREATE TABLE IF NOT EXISTS ExoHumano (
  idExoHumano INT PRIMARY KEY DEFAULT nextval('exohumano_id_seq'),
  nome VARCHAR(50) NOT NULL,
  fk_sala INT NOT NULL,
  FOREIGN KEY (fk_sala) REFERENCES Sala (idSala)
);

CREATE TABLE IF NOT EXISTS Missao (
  idMissao INT PRIMARY KEY DEFAULT nextval('missao_id_seq'),
  nomeMissao VARCHAR(50) NOT NULL,
  recompensa INT NOT NULL,
  itensNecessario CHAR(30),
  objetivo VARCHAR(50) NOT NULL,
  fk_sala INT NOT NULL,
  fk_exohumano INT NOT NULL,
  FOREIGN KEY (fk_sala) REFERENCES Sala (idSala),
  FOREIGN KEY (fk_exohumano) REFERENCES ExoHumano (idExoHumano)
);

CREATE TABLE IF NOT EXISTS Puzzle (
  idPuzzle INT PRIMARY KEY DEFAULT nextval('puzzle_id_seq'), 
  nomePuzzle VARCHAR(30) NOT NULL,
  dificuldade CHAR(10) NOT NULL,
  fk_missao INT NOT NULL,
  FOREIGN KEY (fk_missao) REFERENCES Missao (idMissao)
);

-- Subclasses
CREATE TABLE IF NOT EXISTS Matematico (
  fk_puzzle INT NOT NULL,
  expressao VARCHAR(50) NOT NULL,
  FOREIGN KEY (fk_puzzle) REFERENCES Puzzle (idPuzzle) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Decodificar (
  fk_puzzle INT NOT NULL,
  codigo VARCHAR(50) NOT NULL,
  FOREIGN KEY (fk_puzzle) REFERENCES Puzzle (idPuzzle) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Dialogo (
  idDialogo INT PRIMARY KEY DEFAULT nextval('dialogo_id_seq'),
  nomeDialogo VARCHAR(30) NOT NULL,
  fk_exohumano INT NOT NULL,
  FOREIGN KEY (fk_exohumano) REFERENCES ExoHumano (idExoHumano)
);

CREATE TABLE IF NOT EXISTS CyberLutador (
  idCyberLutador INT PRIMARY KEY DEFAULT nextval('cyberlutador_id_seq'),
  inteligencia INT NOT NULL,
  resistencia INT NOT NULL,
  furtividade INT NOT NULL,
  percepcao INT NOT NULL,
  vida INT NOT NULL,
  velocidade INT NOT NULL,
  fk_player INT NOT NULL,
  fk_inimigo INT NOT NULL,
  FOREIGN KEY (fk_player) REFERENCES ExoHumano (idExoHumano),
  FOREIGN KEY (fk_inimigo) REFERENCES ExoHumano (idExoHumano)
);

CREATE TABLE IF NOT EXISTS Item (
  idItem INT PRIMARY KEY DEFAULT nextval('item_id_seq'),
  nomeItem VARCHAR(50) NOT NULL,
  descricao VARCHAR(255) NOT NULL,
  valor INT NOT NULL
);

CREATE TABLE IF NOT EXISTS InstanciaItem (
  idInstanciaItem INT PRIMARY KEY DEFAULT nextval('instancia_item_id_seq'),
  fk_item INT NOT NULL,
  FOREIGN KEY (fk_item) REFERENCES Item (idItem)
);

CREATE TABLE IF NOT EXISTS NPC (
  idNPC INT PRIMARY KEY DEFAULT nextval('npc_id_seq'),
  nomeNPC VARCHAR(50) NOT NULL,
  fk_sala INT NOT NULL,
  FOREIGN KEY (fk_sala) REFERENCES Sala (idSala)
);

CREATE TABLE IF NOT EXISTS Componente (
  idComponente INT PRIMARY KEY DEFAULT nextval('componente_id_seq'),
  nomeComponente VARCHAR(50) NOT NULL,
  tipo VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Faccao (
  idFaccao INT PRIMARY KEY DEFAULT nextval('faccao_id_seq'),
  nomeFaccao VARCHAR(50) NOT NULL,
  ideologia VARCHAR(255) NOT NULL,
  tecnologia VARCHAR(255) NOT NULL,
  territorio VARCHAR(255) NOT NULL,
  forcaMilitar INT NOT NULL,
  especialidade VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS MercadoClandestino (
  idMercadoClandestino INT PRIMARY KEY DEFAULT nextval('mercado_clandestino_id_seq'),
  nomeMercado VARCHAR(50) NOT NULL,
  produtoFornecido VARCHAR(50) NOT NULL,
  fk_sala INT NOT NULL,
  FOREIGN KEY (fk_sala) REFERENCES Sala (idSala)
);

CREATE TABLE IF NOT EXISTS Mochila (
  idMochila INT PRIMARY KEY DEFAULT nextval('mochila_id_seq'),
  capacidade INT NOT NULL,
  fk_player INT NOT NULL,
  fk_item INT NOT NULL,
  FOREIGN KEY (fk_player) REFERENCES ExoHumano (idExoHumano),
  FOREIGN KEY (fk_item) REFERENCES Item (idItem)
);

CREATE TABLE IF NOT EXISTS Carro(
  idCarro INT PRIMARY KEY DEFAULT nextval('carro_id_seq'),
  capacidade INT NOT NULL,
  velocidade INT NOT NULL,
  combustivel INT NOT NULL,
  preco INT NOT NULL,
  conservacao INT NOT NULL,
  nivelSeguranca INT NOT NULL,
  blindagem INT NOT NULL,
  fk_regiao INT NOT NULL,
  fk_mercado_clandestino INT NOT NULL,
  FOREIGN KEY (fk_regiao) REFERENCES Regiao (idRegiao),
  FOREIGN KEY (fk_mercado_clandestino) REFERENCES MercadoClandestino (idMercadoClandestino)
);

CREATE TABLE IF NOT EXISTS Player(
  idPlayer INT PRIMARY KEY DEFAULT nextval('player_id_seq'),
  inteligencia INT NOT NULL,
  resistencia INT NOT NULL,
  furtividade INT NOT NULL,
  percepcao INT NOT NULL,
  vida INT NOT NULL,
  velocidade INT NOT NULL,
  fk_cyberLutador INT NOT NULL,
  FOREIGN KEY (fk_cyberLutador) REFERENCES CyberLutador (idCyberLutador)
);

CREATE TABLE IF NOT EXISTS Inimigo(
  idInimigo INT PRIMARY KEY DEFAULT nextval('inimigo_id_seq'),
  inteligencia INT NOT NULL,
  resistencia INT NOT NULL,
  furtividade INT NOT NULL,
  percepcao INT NOT NULL,
  vida INT NOT NULL,
  velocidade INT NOT NULL,
  fk_cyberLutador INT NOT NULL,
  FOREIGN KEY (fk_cyberLutador) REFERENCES CyberLutador (idCyberLutador)
);

CREATE TABLE IF NOT EXISTS InstanciaInimigo (
  idInstanciaInimigo INT PRIMARY KEY DEFAULT nextval('instancia_inimigo_id_seq'),
  fk_inimigo INT NOT NULL,
  fk_player INT NOT NULL,
  FOREIGN KEY (fk_inimigo) REFERENCES Inimigo (idInimigo),
  FOREIGN KEY (fk_player) REFERENCES Player (idPlayer)
);

CREATE TABLE IF NOT EXISTS NetRunners (
  idNetRunners INT PRIMARY KEY DEFAULT nextval('netrunners_id_seq'),
  fk_faccao INT NOT NULL,
  FOREIGN KEY (fk_faccao) REFERENCES Faccao (idFaccao)
);

CREATE TABLE IF NOT EXISTS CodeKeepers (
  idCodeKeepers INT PRIMARY KEY DEFAULT nextval('codekeepers_id_seq'),
  fk_faccao INT NOT NULL,
  FOREIGN KEY (fk_faccao) REFERENCES Faccao (idFaccao)
);

CREATE TABLE IF NOT EXISTS VoidWalkers (
  idVoidWalkers INT PRIMARY KEY DEFAULT nextval('voidwalkers_id_seq'),
  fk_faccao INT NOT NULL,
  FOREIGN KEY (fk_faccao) REFERENCES Faccao (idFaccao)
);

CREATE TABLE IF NOT EXISTS Implante (
  idImplante INT PRIMARY KEY DEFAULT nextval('implante_id_seq'),
  nomeImplante VARCHAR(50) NOT NULL,
  tipo VARCHAR(50) NOT NULL,
  localInstalacao VARCHAR(50) NOT NULL,
  upgrade BOOLEAN NOT NULL,
  fk_cyberlutador INT NOT NULL,
  FOREIGN KEY (fk_cyberlutador) REFERENCES CyberLutador (idCyberLutador)
);

CREATE TABLE IF NOT EXISTS VisaoCibernetica (
  fk_implante INT PRIMARY KEY,
  aumentaFurtividade BOOLEAN NOT NULL,
  aumentaPercepcao BOOLEAN NOT NULL,
  FOREIGN KEY (fk_implante) REFERENCES Implante (idImplante) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS BracoRobotico (
  fk_implante INT PRIMARY KEY,
  aumentaVida BOOLEAN NOT NULL,
  aumentaResistencia BOOLEAN NOT NULL,
  FOREIGN KEY (fk_implante) REFERENCES Implante (idImplante) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS CapaceteNeural (
  fk_implante INT PRIMARY KEY,
  aumentaVelocidade BOOLEAN NOT NULL,
  aumentaInteligencia BOOLEAN NOT NULL,
  FOREIGN KEY (fk_implante) REFERENCES Implante (idImplante) ON DELETE CASCADE
);