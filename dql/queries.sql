  -- Arquivo: dql/queries.sql

--Charles

-- Obter as missões em uma sala específica
-- Consultar puzzles em missões específicas
-- Listar implantes cibernéticos de um CyberLutador
-- Buscar itens em uma mochila de um jogador
-- Itens disponíveis no mercado clandestino
-- listar Cyberlutadores
-- Verificar as habilidades de um CyberLutador


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



