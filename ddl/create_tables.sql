-- Criando as sequências primeiro
CREATE SEQUENCE mapa_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE regiao_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE sala_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE exohumano_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE missao_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE puzzle_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE dialogo_id_seq START WITH 1 INCREMENT BY 1;

-- Agora criando as tabelas que dependem das sequências
CREATE TABLE Mapa(
  idMapa INT PRIMARY KEY DEFAULT nextval('mapa_id_seq'),
  nomeMapa VARCHAR(50) NOT NULL
);

CREATE TABLE Regiao(
  idRegiao INT PRIMARY KEY DEFAULT nextval('regiao_id_seq'),
  nomeRegiao VARCHAR(50) NOT NULL,
  fk_mapa INT NOT NULL,
  FOREIGN KEY (fk_mapa) REFERENCES Mapa (idMapa)
);

CREATE TABLE Sala(
  idSala INT PRIMARY KEY DEFAULT nextval('sala_id_seq'),
  nomeSala VARCHAR(50) NOT NULL,
  fk_regiao INT NOT NULL,
  FOREIGN KEY (fk_regiao) REFERENCES Regiao (idRegiao)
);

CREATE TABLE ExoHumano (
  idExoHumano INT PRIMARY KEY DEFAULT nextval('exohumano_id_seq'),
  nome VARCHAR(50) NOT NULL,
  fk_sala INT NOT NULL,
  FOREIGN KEY (fk_sala) REFERENCES Sala (idSala)
);

CREATE TABLE Missao (
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

CREATE TABLE Puzzle (
  idPuzzle INT PRIMARY KEY DEFAULT nextval('puzzle_id_seq'), 
  nomePuzzle VARCHAR(30) NOT NULL,
  dificuldade CHAR(10) NOT NULL,
  fk_missao INT NOT NULL,
  FOREIGN KEY (fk_missao) REFERENCES Missao (idMissao)
);

-- Subclasses
CREATE TABLE Matematico (
  fk_puzzle INT NOT NULL,
  expressao VARCHAR(50) NOT NULL,
  FOREIGN KEY (fk_puzzle) REFERENCES Puzzle (idPuzzle) ON DELETE CASCADE
);

CREATE TABLE Decodificar (
  fk_puzzle INT NOT NULL,
  codigo VARCHAR(50) NOT NULL,
  FOREIGN KEY (fk_puzzle) REFERENCES Puzzle (idPuzzle) ON DELETE CASCADE
);

CREATE TABLE Dialogo (
  idDialogo INT PRIMARY KEY DEFAULT nextval('dialogo_id_seq'),
  nomeDialogo VARCHAR(30) NOT NULL,
  fk_exohumano INT NOT NULL,
  FOREIGN KEY (fk_exohumano) REFERENCES ExoHumano (idExoHumano)
);
