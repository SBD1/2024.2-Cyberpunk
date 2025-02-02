INSERT INTO MercadoClandestino  (nomeMercado, fk_sala)
VALUES ('CyberMercado', (SELECT idSala FROM Sala WHERE nomeSala = 'Cyber Mercado' LIMIT 1))
WHERE NOT EXISTS (SELECT 1 FROM MercadoClandestino WHERE nomeMercado = 'CyberMercado');

INSERT INTO Mercado_Item (fk_mercado_clandestino, fk_instanciaitem)
VALUES ((SELECT idMercadoClandestino FROM MercadoClandestino WHERE nomeMercado = 'CyberMercado' LIMIT 1), (SELECT idInstanciaItem FROM InstanciaItem WHERE fk_item = (SELECT idItem FROM Item WHERE nomeItem = 'Pacote de Dados') LIMIT 1))
WHERE NOT EXISTS (SELECT 1 FROM Mercado_Item WHERE fk_mercado_clandestino = (SELECT idMercadoClandestino FROM MercadoClandestino WHERE nomeMercado = 'CyberMercado' LIMIT 1) AND fk_instanciaitem = (SELECT idInstanciaItem FROM InstanciaItem WHERE fk_item = (SELECT idItem FROM Item WHERE nomeItem = 'Pacote de Dados') LIMIT 1));

