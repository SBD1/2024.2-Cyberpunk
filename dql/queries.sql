  -- Arquivo: dql/queries.sql

-- Obter as missões em uma sala específica
SELECT *
FROM Missao
WHERE fk_sala = <idSala>

-- Consultar puzzles em missões específicas
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

-- Listar implantes cibernéticos de um CyberLutador
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

-- Buscar itens em uma mochila de um jogador
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

-- Itens disponíveis no mercado clandestino
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

-- listar Cyberlutadores
SELECT idCyberLutador, nome
FROM CyberLutador

-- Verificar as habilidades de um CyberLutador
SELECT
    inteligencia,
    resistencia,
    furtividade,
    percepcao,
    vida,
    velocidade
FROM CyberLutador
WHERE idCyberLutador = <idCyberLutador>


-- listar NPCs numa sala e o tipo
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


-- consultar a qual região uma sala pertence
SELECT 
    s.nomeSala AS "Nome da Sala", 
    r.nomeRegiao AS "Região"
FROM Sala s
JOIN Regiao r ON s.fk_regiao = r.idRegiao
WHERE s.nomeSala = 'Cybernetic Warehouse';

-- listar os carros em uma região 
SELECT 
    c.idCarro AS "ID do Carro", 
    c.combustivel AS "Combustível"
FROM Carro c
JOIN Regiao r ON c.fk_regiao = r.idRegiao
WHERE r.nomeRegiao = 'Lower City';

-- consultar facção de um cyberlutador
SELECT 
    f.nomeFaccao AS "Facção", 
    f.ideologia AS "Ideologia"
FROM Faccao f
WHERE f.fk_cyberlutador = 10;

-- Verificar os inimigos enfrentados por um jogador
SELECT 
    i.qtdDano AS "Dano do Inimigo", 
    i.vida AS "Vida do Inimigo", 
    n.nomeNPC AS "Nome do NPC"
FROM InstanciaInimigo ii
JOIN Inimigo i ON ii.fk_inimigo = i.fk_npc
JOIN NPC n ON i.fk_npc = n.idNPC
JOIN Recompensa r ON ii.idInstanciaInimigo = r.fk_instancia_inimigo
WHERE r.fk_cyberlutador = 10;

-- Verificar o progresso em uma missão
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



