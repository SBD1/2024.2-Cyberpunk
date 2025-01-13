# Introdução

<p align="justify">
O projeto utiliza uma estrutura de banco de dados relacional para o jogo da temática cyberpunk. Neste documento, destacamos as consultas, que permitem recuperar informações de diversas tabelas do banco. Abaixo estão detalhadas as funcionalidades implementadas por meio das consultas SQL.
</p>


# Data Query Language 

<p align="justify">
Este documento apresenta as consultas utilizadas no projeto. Cada consulta foi projetada para atender a requisitos específicos do jogo, como buscar informações de missões, jogadores, NPCs, e outros elementos essenciais.
</p>


## Consultas SQL

### Obter as Missões em uma Sala Específica
```sql
SELECT *
FROM Missao
WHERE fk_sala = <idSala>;
```


### Consultar Puzzles em Missões Específicas
```sql
SELECT 
    puzzle.nomePuzzle,
    puzzle.dificuldade,
    CASE 
        WHEN matematico.expressao IS NOT NULL THEN 'Matemático'
        WHEN decodificar.codigo IS NOT NULL THEN 'Decodificar'
        ELSE 'Outro Tipo'
    END AS tipoPuzzle,
    COALESCE(matematico.expressao, decodificar.codigo) AS detalhe,
    puzzle.status
FROM 
    Puzzle puzzle
LEFT JOIN 
    Matematico matematico ON matematico.fk_puzzle = puzzle.idPuzzle
LEFT JOIN 
    Decodificar decodificar ON decodificar.fk_puzzle = puzzle.idPuzzle
WHERE 
    puzzle.fk_missao = <idMissao>;
```

### Listar Implantes Cibernéticos de um CyberLutador
```sql
SELECT 
    implante.nomeImplante,
    implante.tipo,
    implante.localInstalacao,
    implante.upgrade,
    CASE 
        WHEN visaoCibernetica.fk_implante IS NOT NULL THEN 'Visão Cibernética'
        WHEN bracoRobotico.fk_implante IS NOT NULL THEN 'Braço Robótico'
        WHEN capaceteNeural.fk_implante IS NOT NULL THEN 'Capacete Neural'
        ELSE 'Outro'
    END AS tipoEspecifico,
    visaoCibernetica.aumentaFurtividade AS visaoAumentaFurtividade,
    visaoCibernetica.aumentaPercepcao AS visaoAumentaPercepcao,
    bracoRobotico.aumentaVida AS bracoAumentaVida,
    bracoRobotico.aumentaResistencia AS bracoAumentaResistencia,
    capaceteNeural.aumentaVelocidade AS capaceteAumentaVelocidade,
    capaceteNeural.aumentaInteligencia AS capaceteAumentaInteligencia
FROM 
    Implante implante
LEFT JOIN 
    VisaoCibernetica visaoCibernetica ON visaoCibernetica.fk_implante = implante.idImplante
LEFT JOIN 
    BracoRobotico bracoRobotico ON bracoRobotico.fk_implante = implante.idImplante
LEFT JOIN 
    CapaceteNeural capaceteNeural ON capaceteNeural.fk_implante = implante.idImplante
WHERE 
    implante.fk_cyberlutador = <idCyberLutador>;
```

### Buscar Itens em uma Mochila de um Jogador
```sql
SELECT 
    item.nomeItem,
    item.descricao,
    item.valor,
    instancia.idInstanciaItem
FROM 
    Mochila mochila
INNER JOIN 
    InstanciaItem instancia ON instancia.fk_mochila = Mochila.idMochila
INNER JOIN 
    Item item ON instancia.fk_item = item.idItem
WHERE 
    mochila.fk_cyberLutador = <idCyberLutador>;
```

### Itens Disponíveis no Mercado Clandestino
```sql
SELECT 
    item.nomeItem AS NomeDoItem,
    item.descricao AS DescricaoDoItem,
    item.valor AS ValorDoItem,
    mercadoClandestino.nomeMercado AS NomeDoMercado
FROM 
    MercadoClandestino mercadoClandestino
INNER JOIN 
    InstanciaItem instancia ON instancia.fk_mercado_clandestino = mercadoClandestino.idMercadoClandestino
INNER JOIN 
    Item item ON instancia.fk_item = item.idItem
WHERE 
    mercadoClandestino.idMercadoClandestino = <idMercadoClandestino>;
```

### Listar CyberLutadores
```sql
SELECT idCyberLutador, nome
FROM CyberLutador;
```

### Verificar as Habilidades de um CyberLutador
```sql
SELECT
    inteligencia,
    resistencia,
    furtividade,
    percepcao,
    vida,
    velocidade
FROM CyberLutador
WHERE idCyberLutador = <idCyberLutador>;
```

### Listar NPCs em uma Sala e o Tipo
```sql
SELECT 
    n.nomeNPC AS "Nome do NPC", 
    CASE 
        WHEN m.fk_npc IS NOT NULL THEN 'Mentor' 
        WHEN i.fk_npc IS NOT NULL THEN 'Inimigo' 
        ELSE 'Outro'
    END AS "Tipo do NPC"
FROM NPC n
LEFT JOIN Mentor m ON n.idNPC = m.fk_npc
LEFT JOIN Inimigo i ON n.idNPC = i.fk_npc
WHERE n.fk_sala = 1;
```

### Consultar a Qual Região uma Sala Pertence
```sql
SELECT 
    s.nomeSala AS "Nome da Sala", 
    r.nomeRegiao AS "Região"
FROM Sala s
JOIN Regiao r ON s.fk_regiao = r.idRegiao
WHERE s.nomeSala = 'Cybernetic Warehouse';
```

### Listar os Carros em uma Região
```sql
SELECT 
    c.idCarro AS "ID do Carro", 
    c.combustivel AS "Combustível"
FROM Carro c
JOIN Regiao r ON c.fk_regiao = r.idRegiao
WHERE r.nomeRegiao = 'Lower City';
```

### Consultar Facção de um CyberLutador
```sql
SELECT 
    f.nomeFaccao AS "Facção", 
    f.ideologia AS "Ideologia"
FROM Faccao f
WHERE f.fk_cyberlutador = 10;
```

### Verificar os Inimigos Enfrentados por um Jogador
```sql
SELECT 
    i.qtdDano AS "Dano do Inimigo", 
    i.vida AS "Vida do Inimigo", 
    n.nomeNPC AS "Nome do NPC"
FROM InstanciaInimigo ii
JOIN Inimigo i ON ii.fk_inimigo = i.fk_npc
JOIN NPC n ON i.fk_npc = n.idNPC
JOIN Recompensa r ON ii.idInstanciaInimigo = r.fk_instancia_inimigo
WHERE r.fk_cyberlutador = 10;
```

### Verificar o Progresso em uma Missão
```sql
SELECT 
    m.id AS id_missao,
    m.nome,
    COUNT(p.id) AS total_puzzles,
    COUNT(CASE WHEN p.status = TRUE THEN 1 END) AS puzzles_resolvidos,
    (COUNT(CASE WHEN p.status = TRUE THEN 1 END) * 1.0 / COUNT(p.id)) * 100 AS progresso
FROM 
    missoes m
LEFT JOIN 
    puzzles p ON m.id = p.id_missao
GROUP BY 
    m.id, m.nome;
```


# Referência Bibliográfica

> <a id="REF1" href="#anchor_1">1.</a> ELMASRI, Ramez; NAVATHE, Shamkant B. Sistemas de banco de dados. Tradução: Daniel Vieira. Revisão técnica: Enzo Seraphim; Thatyana de Faria Piola Seraphim. 6. ed. São Paulo: Pearson Addison Wesley, 2011. Capítulo 2 Conceitos e arquitetura do sistema de banco de dados, tópico 2.3 Linguagens e interfaces do banco de dados, páginas 24 e 25.

> <a id="REF2" href="#anchor_2">2.</a> SILBERSCHATZ, Abraham; KORTH, Henry F.; SUDARSHAN, S. Database system concepts. 6. ed. New York: McGraw-Hill, 2011. Capítulo 1 Introduction, tópico 1.4.2 Data-Definition Language, páginas 12 a 13.

## Histórico de versões
| Versão |  Data  | Descrição | Autor | 
|:------:|:------:|:---------:|------:|
| 1.0 | 06/01/2024 | Criação do Documento| [Gabrielly Assunção](https://github.com/GabriellyAssuncao) |
| 1.1 |  13/01/2025 | Adicionando introdução e script explicado do DML| [Maria Eduarda Marques](https://github.com/EduardaSMarques) e [Charles Serafim Morais](https://github.com/charles-serafim) |
