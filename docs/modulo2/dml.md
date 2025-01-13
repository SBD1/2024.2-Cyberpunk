# Introdução

<p align="justify">
Este documento aborda o uso de Data Manipulation Language para a criação e manipulação de dados, no contexto do jogo cyberpunk, adotado como temática do projeto do grupo. Inclui inserções, atualizações e exclusões de registros em tabelas relacionadas a regiões, salas, personagens, missões, recompensas, puzzles, diálogos e outros elementos do jogo.
</p>

# Data Manipulation Language 

<p align="justify">
O Data Manipulation Language é um conjunto de comandos SQL utilizado para manipular os dados armazenados nas tabelas. Ele inclui operações como inserção, atualização e exclusão de registros. No projeto, as operações DML implementam a lógica do jogo, como a criação de personagens, missões, itens e interações entre eles.
</p>

<p align="justify">
Enquanto o DML se concentra na manipulação de dados, a consulta desses dados é feita na seção Data Query Language, onde comandos como *SELECT* são usados para recuperar informações do banco de dados.
</p>

<p align="justify">
Abaixo, estão descritas as seções do projeto que utilizam comandos DML para criar e gerenciar os elementos do jogo.
</p>

### Regiões
Essa tabela armazena as diferentes regiões do jogo. Cada região tem um identificador único e um nome.
```sql
INSERT INTO Regiao (idRegiao, nomeRegiao) 
  VALUES (1, 'Regiao Inicial');
```

### Salas
As salas pertencem a uma região e representam os espaços que os jogadores podem explorar. A chave estrangeira `fk_regiao` associa cada sala à sua respectiva região.
```sql
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
```

### ExoHumanos
Os ExoHumanos são personagens presentes no jogo, associados a uma sala específica.
```sql
INSERT INTO ExoHumano (idExoHumano, nome, fk_sala)
  VALUES (1,'ExoHumano Inicial', 1);
```

### Missões
As missões são desafios que os jogadores devem completar. Cada missão está associada a uma sala e a um CyberLutador específico. 
```sql
INSERT INTO Missao (idMissao, nomeMissao, descricao, fk_sala, fk_cyberlutador)
  VALUES (1, 'Missao Inicial', 'Descricao 1', 1, 1),
         (2, 'Decodificação inicial', 'Descricao 2', 2, 1);
```

### Recompensas
As recompensas são atribuídas a missões ou a combates contra inimigos. 
```sql
INSERT INTO Recompensa (idRecompensa, dinheiro, item, fk_instancia_inimigo, fk_cyberlutador)
  VALUES (1, 100, 'Item Recompensa Inicial', 1, 1);

INSERT INTO RecompensaMissao (idRecompensaMissao, dinheiro, item, fk_sala, fk_cyberLutador)
  VALUES (1, 100, 'Item Recompensa Missao Inicial', 1, 1);
```

### Puzzles
Os puzzles são desafios que os jogadores precisam resolver dentro de uma missão. Eles podem ser de tipos diferentes, como matemáticos ou de decodificação.
```sql
INSERT INTO Puzzle (idPuzzlle, nomePuzzle, dificuldade, fk_missao)
  VALUES (1, 'Puzzle Inicial', 'Facil', 1);

INSERT INTO Matematico (fk_puzzle, expressao)
  VALUES (1, '2 + 2 = ?');

INSERT INTO Decodificar (fk_puzzle, codigo)
  VALUES (2, 'A = 1, B = 2, C = 3, D = 4, E = 5, F = 6, G = 7, H = 8, I = 9, J = 10, K = 11, L = 12, M = 13, N = 14, O = 15, P = 16, Q = 17, R = 18, S = 19, T = 20, U = 21, V = 22, W = 23, X = 24, Y = 25, Z = 26');
```

### Diálogos
Os diálogos são frases associadas aos NPCs para interagir com os jogadores em diferentes salas.
```sql
INSERT INTO Dialogo (idDialogo, nomeDialogo, fk_npc)
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
```

### CyberLutadores
Os CyberLutadores são os personagens controlados pelos jogadores. Seus atributos podem ser atualizados conforme o progresso do jogo.
```sql
INSERT INTO CyberLutador (idCyber, inteligencia, resistencia, furtividade, percepcao, vida, velocidade, forca)
  VALUES (1, 10, 10, 10, 10, 100, 10, 10);

UPDATE CyberLutador
  SET inteligencia = inteligencia + num,
      resistencia = resistencia + num,
      furtividade = furtividade + num,
      percepcao = percepcao + num,
      vida = vida + num,
      velocidade = velocidade + num,
      forca = forca + num
  WHERE idCyber = 1;
```

### Itens
Os itens representam os objetos que os jogadores podem coletar e usar ao longo do jogo.
```sql
INSERT INTO Item (idItem, nomeItem, descricao, valor)
  VALUES (1, 'Item Inicial', 'Item de teste', 100);

INSERT INTO InstanciaItem (idInstanciaItem, fk_item)
  VALUES (1, 1);

DELETE FROM InstanciaItem
  WHERE idInstanciaItem = 1;
```

### NPCs
Os NPCs fornecem interações e desafios aos jogadores.
```sql
INSERT INTO NPC (idNPC, nomeNPC, descricao, fk_sala)
  VALUES (1, 'NPC Inicial', 'Descricao npc 1', 1);

INSERT INTO Mentor (fk_npc, aumentaInteligencia, aumentaFurtividade, aumentaPercepcao)
  VALUES (1, 10, 10, 10);
```

### Facções
As facções agrupam CyberLutadores com ideologias e habilidades específicas.
```sql
INSERT INTO Faccao (idFaccao, fk_cyberlutador, nomeFaccao, ideologia)
  VALUES (1, 1, 'Faccao Teste', 'Ideologia de teste'),
         (2, 2, 'NetRunners', 'Ideologia NetRunners'),
         (3, 3, 'CodeKeepers', 'Ideologia CodeKeepers'),
         (4, 4, 'VoidWalkers', 'Ideologia VoidWalkers');

INSERT INTO NetRunners (idNetRunners, fk_faccao, aumentaInte, aumentaPercep)
  VALUES (1, 1, 10, 10);

INSERT INTO CodeKeepers (idCodeKeepers, fk_faccao, aumentaVelo, aumentaResis)
  VALUES (2, 2, 10, 10);
```

### Mercado Clandestino
Representa os mercados onde os jogadores podem negociar itens.
```sql
INSERT INTO MercadoClandestino (idMercadoClandestino, nomeMercado, desccricao, fk_sala)
  VALUES (1, 'Mercado Inicial', 'Descricao teste', 1);
```

### Mochilas
As mochilas armazenam itens coletados pelos jogadores durante o jogo.
```sql
INSERT INTO Mochila (idMochila, capacidade, fk_cyberlutador, fk_instanciaitem)
  VALUES (1, 50, 1, 1);
```

### Carros
Os carros são meios de transporte associados a uma região específica.
```sql
INSERT INTO Carro (idCarro, combustivel, fk_regiao)
  VALUES (1, 50, 1);
```

### Inimigos
Os inimigos oferecem desafios de combate aos jogadores.
```sql
INSERT INTO Inimigo (qtdDano, vida, fk_npc)
  VALUES (10, 100, 1);

INSERT INTO InstanciaInimigo (idInstanciaInimigo, fk_inimigo)
  VALUES (1, 1);

UPDATE InstanciaInimigo
  SET qtdDano = qtdDano + num,
      vida = vida + num
  WHERE idInstanciaInimigo = 1;

DELETE FROM InstanciaInimigo
  WHERE idInstanciaInimigo = 1;
```

### Implantes
Os implantes oferecem melhorias aos CyberLutadores, aumentando suas capacidades no jogo.
```sql
INSERT INTO Implante (idImplante, nomeImplante, tipo, fk_cyberLutador)
  VALUES (1, 'Implante Inicial', 'Implante de teste', 1);
```

# Referência Bibliográfica

> <a id="REF1" href="#anchor_1">1.</a> ELMASRI, Ramez; NAVATHE, Shamkant B. Sistemas de banco de dados. Tradução: Daniel Vieira. Revisão técnica: Enzo Seraphim; Thatyana de Faria Piola Seraphim. 6. ed. São Paulo: Pearson Addison Wesley, 2011. Capítulo 2 Conceitos e arquitetura do sistema de banco de dados, tópico 2.3 Linguagens e interfaces do banco de dados, páginas 24 e 25.

> <a id="REF2" href="#anchor_2">2.</a> SILBERSCHATZ, Abraham; KORTH, Henry F.; SUDARSHAN, S. Database system concepts. 6. ed. New York: McGraw-Hill, 2011. Capítulo 1 Introduction, tópico 1.4.2 Data-Definition Language, páginas 12 a 13.

## Histórico de versões
| Versão |  Data  | Descrição | Autor | 
|:------:|:------:|:---------:|------:|
| 1.0 | 06/01/2025 | Criação do Documento| [Gabrielly Assunção](https://github.com/GabriellyAssuncao) |
| 1.1 |  12/01/2025 | Adicionando introdução e script explicado do DML| [Maria Eduarda Marques](https://github.com/EduardaSMarques) e [Lucas Meireles](https://github.com/Katuner)|

