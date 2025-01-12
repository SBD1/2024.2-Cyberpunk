  -- Arquivo: dql/queries.sql

--Charles

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

-- Maria 

-- listar NPCs numa sala e o tipo
-- consultar a qual região uma sala pertence
-- listar os carros em uma região 
-- consultar facção de um cyberlutador
-- Verificar o progresso em uma missão
-- Verificar os inimigos enfrentados por um jogador
-- Verificar o progresso em uma missão



