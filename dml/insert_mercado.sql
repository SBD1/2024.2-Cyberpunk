INSERT INTO MercadoClandestino (nomeMercado, descricao, fk_sala)
SELECT 'Mercado Secreto', 'Mercado inicial', (SELECT idSala FROM Sala WHERE nomeSala = 'Cyber Mercado' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM MercadoClandestino WHERE nomeMercado = 'Mercado Secreto');


INSERT INTO Item (nomeItem, descricao, valor)
SELECT 'Pacote de Dados', 'Pacote de dados para hackear', 100
WHERE NOT EXISTS (SELECT 1 FROM Item WHERE nomeItem = 'Pacote de Dados');

INSERT INTO InstanciaItem (fk_item)
SELECT (SELECT idItem FROM Item WHERE nomeItem = 'Pacote de Dados' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM InstanciaItem WHERE fk_item = (SELECT idItem FROM Item WHERE nomeItem = 'Pacote de Dados' LIMIT 1));

INSERT INTO Mercado_Item (fk_mercado_clandestino, fk_instanciaitem)
SELECT 
    (SELECT idMercadoClandestino FROM MercadoClandestino WHERE nomeMercado = 'Mercado Secreto' LIMIT 1),
    (SELECT idInstanciaItem FROM InstanciaItem WHERE fk_item = (SELECT idItem FROM Item WHERE nomeItem = 'Pacote de Dados') LIMIT 1)
WHERE NOT EXISTS (
    SELECT 1 
    FROM Mercado_Item 
    WHERE fk_mercado_clandestino = (SELECT idMercadoClandestino FROM MercadoClandestino WHERE nomeMercado = 'Mercado Secreto' LIMIT 1) 
    AND fk_instanciaitem = (SELECT idInstanciaItem FROM InstanciaItem WHERE fk_item = (SELECT idItem FROM Item WHERE nomeItem = 'Pacote de Dados') LIMIT 1)
);


