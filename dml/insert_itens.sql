INSERT INTO Item (nomeItem, descricao, valor)
SELECT 'Pacote de Dados', 'Pacote de dados para hackear', 100
WHERE NOT EXISTS (SELECT 1 FROM Item WHERE nomeItem = 'Pacote de Dados');

INSERT INTO InstanciaItem (fk_item)
SELECT (SELECT idItem FROM Item WHERE nomeItem = 'Pacote de Dados' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM InstanciaItem WHERE fk_item = (SELECT idItem FROM Item WHERE nomeItem = 'Pacote de Dados' LIMIT 1));


INSERT INTO Item (nomeItem, descricao, valor)
SELECT 'Biochip de Regeneração', 'Aumenta a regeneração celular', 500
WHERE NOT EXISTS (SELECT 1 FROM Item WHERE nomeItem = 'Biochip de Regeneração');

INSERT INTO InstanciaItem (fk_item)
SELECT (SELECT idItem FROM Item WHERE nomeItem = 'Biochip de Regeneração' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM InstanciaItem WHERE fk_item = (SELECT idItem FROM Item WHERE nomeItem = 'Biochip de Regeneração' LIMIT 1));

-- Inserindo Implantes
INSERT INTO Item (nomeItem, descricao, valor)
SELECT 'Braço Cibernético', 'Aumenta a força e velocidade', 1000
WHERE NOT EXISTS (SELECT 1 FROM Item WHERE nomeItem = 'Braço Cibernético');

INSERT INTO InstanciaItem (fk_item)
SELECT (SELECT idItem FROM Item WHERE nomeItem = 'Braço Cibernético' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM InstanciaItem WHERE fk_item = (SELECT idItem FROM Item WHERE nomeItem = 'Braço Cibernético' LIMIT 1));


INSERT INTO Item (nomeItem, descricao, valor)
SELECT 'Bloqueador de Hack Mental', 'Protege contra ataques de invasão cerebral', 5000
WHERE NOT EXISTS (SELECT 1 FROM Item WHERE nomeItem = 'Bloqueador de Hack Mental');

INSERT INTO InstanciaItem (fk_item)
SELECT (SELECT idItem FROM Item WHERE nomeItem = 'Bloqueador de Hack Mental' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM InstanciaItem WHERE fk_item = (SELECT idItem FROM Item WHERE nomeItem = 'Bloqueador de Hack Mental' LIMIT 1));


INSERT INTO Item (nomeItem, descricao, valor)
SELECT 'Rastreamento de Alvos', 'Aumenta a percepção de inimigos e prevê movimentos', 3000
WHERE NOT EXISTS (SELECT 1 FROM Item WHERE nomeItem = 'Rastreamento de Alvos');

INSERT INTO InstanciaItem (fk_item)
SELECT (SELECT idItem FROM Item WHERE nomeItem = 'Rastreamento de Alvos' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM InstanciaItem WHERE fk_item = (SELECT idItem FROM Item WHERE nomeItem = 'Rastreamento de Alvos' LIMIT 1));