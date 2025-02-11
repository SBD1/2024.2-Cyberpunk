INSERT INTO MercadoClandestino (nomeMercado, descricao, fk_sala)
SELECT 'Mercado Secreto', 'Mercado inicial', (SELECT idSala FROM Sala WHERE nomeSala = 'Cyber Mercado' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM MercadoClandestino WHERE nomeMercado = 'Mercado Secreto');

-- Itens sendo criados

INSERT INTO Item (nomeItem, descricao, valor)
SELECT 'Pacote de Dados', 'Pacote de dados para hackear', 100
WHERE NOT EXISTS (SELECT 1 FROM Item WHERE nomeItem = 'Pacote de Dados');

INSERT INTO Item (nomeItem, descricao, valor)
SELECT 'Dispositivo Defeituoso', 'Um dispositivo claramente não funcional, você realmente precisa disto?', 5
WHERE NOT EXISTS (SELECT 1 FROM Item WHERE nomeItem = 'Dispositivo Defeituoso');

INSERT INTO Item (nomeItem, descricao, valor)
SELECT 'Cartão Fidelidade', 'Um Cartão que apenas os realmente fiéis do mercado conseguem adquirir', 3000
WHERE NOT EXISTS (SELECT 1 FROM Item WHERE nomeItem = 'Cartão Fidelidade');

-- Gerando ao menos 1 instância do item

INSERT INTO InstanciaItem (fk_item)
SELECT (SELECT idItem FROM Item WHERE nomeItem = 'Pacote de Dados' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM InstanciaItem WHERE fk_item = (SELECT idItem FROM Item WHERE nomeItem = 'Pacote de Dados' LIMIT 1));

INSERT INTO InstanciaItem (fk_item)
SELECT (SELECT idItem FROM Item WHERE nomeItem = 'Dispositivo Defeituoso' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM InstanciaItem WHERE fk_item = (SELECT idItem FROM Item WHERE nomeItem = 'Dispositivo Defeituoso' LIMIT 1));

INSERT INTO InstanciaItem (fk_item)
SELECT (SELECT idItem FROM Item WHERE nomeItem = 'Cartão Fidelidade' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM InstanciaItem WHERE fk_item = (SELECT idItem FROM Item WHERE nomeItem = 'Cartão Fidelidade' LIMIT 1));

-- Relacionando os itens com o mercado

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

INSERT INTO Mercado_Item (fk_mercado_clandestino, fk_instanciaitem)
SELECT
    (SELECT idMercadoClandestino FROM MercadoClandestino WHERE nomeMercado = 'Mercado Secreto' LIMIT 1),
    (SELECT idInstanciaItem FROM InstanciaItem WHERE fk_item = (SELECT idItem FROM Item WHERE nomeItem = 'Dispositivo Defeituoso') LIMIT 1)
WHERE NOT EXISTS (
    SELECT 1 
    FROM Mercado_Item 
    WHERE fk_mercado_clandestino = (SELECT idMercadoClandestino FROM MercadoClandestino WHERE nomeMercado = 'Mercado Secreto' LIMIT 1) 
    AND fk_instanciaitem = (SELECT idInstanciaItem FROM InstanciaItem WHERE fk_item = (SELECT idItem FROM Item WHERE nomeItem = 'Dispositivo Defeituoso') LIMIT 1)
);

INSERT INTO Mercado_Item (fk_mercado_clandestino, fk_instanciaitem)
SELECT
    (SELECT idMercadoClandestino FROM MercadoClandestino WHERE nomeMercado = 'Mercado Secreto' LIMIT 1),
    (SELECT idInstanciaItem FROM InstanciaItem WHERE fk_item = (SELECT idItem FROM Item WHERE nomeItem = 'Cartão Fidelidade') LIMIT 1)
WHERE NOT EXISTS (
    SELECT 1 
    FROM Mercado_Item 
    WHERE fk_mercado_clandestino = (SELECT idMercadoClandestino FROM MercadoClandestino WHERE nomeMercado = 'Mercado Secreto' LIMIT 1) 
    AND fk_instanciaitem = (SELECT idInstanciaItem FROM InstanciaItem WHERE fk_item = (SELECT idItem FROM Item WHERE nomeItem = 'Cartão Fidelidade') LIMIT 1)
);
