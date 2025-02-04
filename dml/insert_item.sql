-- Inserindo um BioChip
INSERT INTO Item (nomeItem, descricao, valor, fk_mercadoClandestino)
VALUES ('Biochip de Regeneração', 'Aumenta a regeneração celular', 500, 1);

INSERT INTO Biochip (fk_item, regeneraVida)
VALUES (1, 20);

-- Inserindo Implantes
INSERT INTO Item (nomeItem, descricao, valor, fk_mercadoClandestino)
VALUES 
('Braço Cibernético', 'Aumenta a força e velocidade', 1000, 1),
('Bloqueador de Hack Mental', 'Protege contra ataques de invasão cerebral', 5000, 1),
('Rastreamento de Alvos', 'Aumenta a percepção de inimigos e prevê movimentos', 3000, 1);

INSERT INTO Implante (fk_item, nomeImplante, tipo)
VALUES 
(2, 'Braço Cibernético', 'Braço Robótico'),
(3, 'Bloqueador de Hack Mental', 'Capacete Neural'),
(4, 'Rastreamento de Alvos', 'Visão Cibernética');

-- Associando Implantes às especializações
INSERT INTO BracoRobotico (fk_implante, aumentaForca, aumentaVeloc)
VALUES (2, 10, 15);

INSERT INTO CapaceteNeural (fk_implante, aumentaInt, aumentaResis)
VALUES (3, 10, 20);

INSERT INTO VisaoCibernetica (fk_implante, aumentaFurti, aumentaPercep)
VALUES (4, 15, 15);

