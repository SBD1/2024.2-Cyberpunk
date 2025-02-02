INSERT INTO MercadoClandestino  (nomeMercado, fk_sala)
VALUES ('CyberMercado', (SELECT idSala FROM Sala WHERE nomeSala = 'Cyber Mercado' LIMIT 1))
WHERE NOT EXISTS (SELECT 1 FROM MercadoClandestino WHERE nomeMercado = 'CyberMercado');

INSERT INTO InstanciaItem (fk_item, fk_mercado_clandestino)
VALUES ((SELECT idItem FROM Item WHERE nomeItem = 'Pacote de Dados'), (SELECT idMercadoClandestino FROM MercadoClandestino WHERE nomeMercado = 'CyberMercado' LIMIT 1));

