# Introdução

<p align="justify">
Este documento tem como objetivo apresentar de forma detalhada o uso da DDL (Data Definition Language) no contexto do projeto. A ênfase será em como essas operações são empregadas para definir e organizar o esquema do banco de dados, assegurando que a estrutura seja robusta, flexível e eficiente. O intuito é proporcionar uma base sólida para as operações subsequentes de manipulação de dados, garantindo, ao longo do ciclo de vida do sistema, a integridade e a consistência dos dados.
</p>

# Data Definition Language

<p align="justify">
Data Definition Language (DDL) é um elemento fundamental na gestão de bancos de dados, sendo responsável pela definição e organização do esquema de dados. Através da DDL, é possível criar, modificar e excluir objetos em um banco de dados, como tabelas, índices e visões. Ela também permite estabelecer restrições e garantir a integridade referencial, assegurando que os dados sejam armazenados de forma consistente e estruturada.
</p>
<p align="justify">
Segundo Silberschatz, Korth e Sudarshan (2011), a DDL desempenha um papel fundamental na definição tanto do layout físico quanto da organização lógica dos dados. Comandos como CREATE, ALTER e DROP são empregados para estabelecer a arquitetura do banco de dados, que serve como alicerce para as operações subsequentes de manipulação de dados (DML). Além de definir a estrutura do banco de dados, a DDL exerce uma influência direta no desempenho e na eficiência das operações de consulta e manipulação de dados, pois possibilita a otimização da organização interna dos dados.
</p>


??? Tabelas

    ```sql
    CREATE TABLE IF NOT EXISTS Regiao (
      idRegiao INT PRIMARY KEY DEFAULT nextval('regiao_id_seq'),
      nomeRegiao VARCHAR(50) NOT NULL
    );

    CREATE TABLE IF NOT EXISTS Sala (
      idSala INT PRIMARY KEY DEFAULT nextval('sala_id_seq'),
      nomeSala VARCHAR(50) NOT NULL,
      fk_regiao INT NOT NULL,
      FOREIGN KEY (fk_regiao) REFERENCES Regiao (idRegiao) ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS CyberLutador (
      idCyber INT PRIMARY KEY DEFAULT nextval('cyberlutador_id_seq'),
      inteligencia INT NOT NULL,
      resistencia INT NOT NULL,
      furtividade INT NOT NULL,
      percepcao INT NOT NULL,
      vida INT NOT NULL,
      velocidade INT NOT NULL,
      forca INT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS NPC (
      idNPC INT PRIMARY KEY DEFAULT nextval('npc_id_seq'),
      nomeNPC VARCHAR(50) NOT NULL,
      descricao VARCHAR(255) NOT NULL,
      fk_sala INT NOT NULL,
      FOREIGN KEY (fk_sala) REFERENCES Sala (idSala) ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS Missao (
      idMissao INT PRIMARY KEY DEFAULT nextval('missao_id_seq'),
      nomeMissao VARCHAR(50) NOT NULL,
      descricao VARCHAR(255) NOT NULL,
      fk_sala INT NOT NULL,
      fk_cyberlutador INT NOT NULL,
      FOREIGN KEY (fk_sala) REFERENCES Sala (idSala) ON DELETE CASCADE, 
      FOREIGN KEY (fk_cyberlutador) REFERENCES CyberLutador (idCyber) ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS Puzzle (
      idPuzzle INT PRIMARY KEY DEFAULT nextval('puzzle_id_seq'),
      nomePuzzle VARCHAR(30) NOT NULL,
      dificuldade VARCHAR(10) NOT NULL,
      fk_missao INT NOT NULL,
      FOREIGN KEY (fk_missao) REFERENCES Missao (idMissao) ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS Matematico (
      fk_puzzle INT PRIMARY KEY,
      expressao VARCHAR(50) NOT NULL,
      FOREIGN KEY (fk_puzzle) REFERENCES Puzzle (idPuzzle) ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS Decodificar (
      fk_puzzle INT PRIMARY KEY,
      codigo VARCHAR(50) NOT NULL,
      FOREIGN KEY (fk_puzzle) REFERENCES Puzzle (idPuzzle) ON DELETE CASCADE
    );

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

    CREATE TABLE IF NOT EXISTS Dialogo (
      idDialogo INT PRIMARY KEY DEFAULT nextval('dialogo_id_seq'),
      nomeDialogo VARCHAR(30) NOT NULL,
      fk_npc INT NOT NULL,
      FOREIGN KEY (fk_npc) REFERENCES NPC (idNPC) ON DELETE CASCADE
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
      FOREIGN KEY (fk_item) REFERENCES Item (idItem) ON DELETE CASCADE
    );


    CREATE TABLE IF NOT EXISTS Faccao (
      idFaccao INT PRIMARY KEY DEFAULT nextval('faccao_id_seq'),
      fk_cyberlutador INT NOT NULL,
      nomeFaccao VARCHAR(50) NOT NULL,
      ideologia VARCHAR(255) NOT NULL,
      FOREIGN KEY (fk_cyberlutador) REFERENCES CyberLutador (idCyber) ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS Recompensa (
      idRecompensa INT PRIMARY KEY DEFAULT nextval('recompensa_id_seq'),
      dinheiro INT NOT NULL,
      item VARCHAR(50),
      fk_instancia_inimigo INT NOT NULL,
      fk_cyberlutador INT NOT NULL,
      FOREIGN KEY (fk_instancia_inimigo) REFERENCES InstanciaInimigo (idInstanciaInimigo) ON DELETE CASCADE,
      FOREIGN KEY (fk_cyberlutador) REFERENCES CyberLutador (idCyber) ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS RecompensaMissao (
      idRecompensaMissao INT PRIMARY KEY DEFAULT nextval('recompensamissao_id_seq'),
      dinheiro INT NOT NULL,
      item VARCHAR(50),
      fk_sala INT NOT NULL,
      fk_cyberlutador INT NOT NULL,
      FOREIGN KEY (fk_sala) REFERENCES Sala (idSala) ON DELETE CASCADE,
      FOREIGN KEY (fk_cyberlutador) REFERENCES CyberLutador (idCyber) ON DELETE CASCADE
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

    CREATE TABLE IF NOT EXISTS Mochila (
      idMochila INT PRIMARY KEY DEFAULT nextval('mochila_id_seq'),
      capacidade INT NOT NULL,
      fk_cyberlutador INT NOT NULL,
      fk_instanciaitem INT NOT NULL,
      FOREIGN KEY (fk_cyberlutador) REFERENCES CyberLutador (idCyber) ON DELETE CASCADE,
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
      FOREIGN KEY (fk_item) REFERENCES Item (idItem) ON DELETE CASCADE
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
    ```


# Referência Bibliográfica

> <a id="REF1" href="#anchor_1">1.</a> ELMASRI, Ramez; NAVATHE, Shamkant B. Sistemas de banco de dados. Tradução: Daniel Vieira. Revisão técnica: Enzo Seraphim; Thatyana de Faria Piola Seraphim. 6. ed. São Paulo: Pearson Addison Wesley, 2011. Capítulo 2 Conceitos e arquitetura do sistema de banco de dados, tópico 2.3 Linguagens e interfaces do banco de dados, páginas 24 e 25.

> <a id="REF2" href="#anchor_2">2.</a> SILBERSCHATZ, Abraham; KORTH, Henry F.; SUDARSHAN, S. Database system concepts. 6. ed. New York: McGraw-Hill, 2011. Capítulo 1 Introduction, tópico 1.4.2 Data-Definition Language, páginas 12 a 13.

## Histórico de versões
| Versão |  Data  | Descrição | Autor | 
|:------:|:------:|:---------:|------:|
| 1.0 | 06/01/2024 | Criação do Documento| [Gabrielly Assunção](https://github.com/GabriellyAssuncao) |
| 1.1 | 10/01/2024 | Adicionando tabelas| [Gabrielly Assunção](https://github.com/GabriellyAssuncao)  e [João Victor](https://github.com/Jauzimm)|
