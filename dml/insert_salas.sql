INSERT INTO Regiao (nomeRegiao)
SELECT 'Darknet Town'
WHERE NOT EXISTS (SELECT 1 FROM Regiao WHERE nomeRegiao = 'Darknet Town');

INSERT INTO Regiao (nomeRegiao)
SELECT 'Área 404'
WHERE NOT EXISTS (SELECT 1 FROM Regiao WHERE nomeRegiao = 'Área 404');

SELECT * FROM Regiao;

INSERT INTO Sala (nomeSala, fk_regiao)
SELECT 'Laboratorio', (SELECT idRegiao FROM Regiao WHERE nomeRegiao = 'Darknet Town' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM Sala WHERE nomeSala = 'Laboratorio');

INSERT INTO Sala (nomeSala, fk_regiao)
SELECT 'Ruinas Ciberneticas', (SELECT idRegiao FROM Regiao WHERE nomeRegiao = 'Darknet Town' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM Sala WHERE nomeSala = 'Ruinas Ciberneticas');

INSERT INTO Sala (nomeSala, fk_regiao)
SELECT 'Distrito Neon', (SELECT idRegiao FROM Regiao WHERE nomeRegiao = 'Darknet Town' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM Sala WHERE nomeSala = 'Distrito Neon');

INSERT INTO Sala (nomeSala, fk_regiao)
SELECT 'Beco Data Stream', (SELECT idRegiao FROM Regiao WHERE nomeRegiao = 'Darknet Town' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM Sala WHERE nomeSala = 'Beco Data Stream');

INSERT INTO Sala (nomeSala, fk_regiao)
SELECT 'Cyber Mercado', (SELECT idRegiao FROM Regiao WHERE nomeRegiao = 'Darknet Town' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM Sala WHERE nomeSala = 'Cyber Mercado');

INSERT INTO Sala (nomeSala, fk_regiao)
SELECT 'Submundo Hacker', (SELECT idRegiao FROM Regiao WHERE nomeRegiao = 'Darknet Town' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM Sala WHERE nomeSala = 'Submundo Hacker');

INSERT INTO Sala (nomeSala, fk_regiao)
SELECT 'Camara de Criptografia', (SELECT idRegiao FROM Regiao WHERE nomeRegiao = 'Darknet Town' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM Sala WHERE nomeSala = 'Camara de Criptografia');

INSERT INTO Sala (nomeSala, fk_regiao)
SELECT 'Refúgio Rebelde', (SELECT idRegiao FROM Regiao WHERE nomeRegiao = 'Darknet Town' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM Sala WHERE nomeSala = 'Refúgio Rebelde');

INSERT INTO Sala (nomeSala, fk_regiao)
SELECT 'Acesso Restrito', (SELECT idRegiao FROM Regiao WHERE nomeRegiao = 'Darknet Town' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM Sala WHERE nomeSala = 'Acesso Restrito');

INSERT INTO Sala (nomeSala, fk_regiao)
SELECT 'Posto de Trocas', (SELECT idRegiao FROM Regiao WHERE nomeRegiao = 'Darknet Town' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM Sala WHERE nomeSala = 'Posto de Trocas');

INSERT INTO Sala (nomeSala, fk_regiao)
SELECT 'Túnel Cibernético Secreto', (SELECT idRegiao FROM Regiao WHERE nomeRegiao = 'Darknet Town' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM Sala WHERE nomeSala = 'Túnel Cibernético Secreto');

INSERT INTO Sala (nomeSala, fk_regiao)
SELECT 'Terminal Nexus Desativado', (SELECT idRegiao FROM Regiao WHERE nomeRegiao = 'Darknet Town' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM Sala WHERE nomeSala = 'Terminal Nexus Desativado');

INSERT INTO Sala (nomeSala, fk_regiao)
SELECT 'Neon Rift', (SELECT idRegiao FROM Regiao WHERE nomeRegiao = 'Área 404' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM Sala WHERE nomeSala = 'Neon Rift');

INSERT INTO Sala (nomeSala, fk_regiao)
SELECT 'Arranha-céu Digital', (SELECT idRegiao FROM Regiao WHERE nomeRegiao = 'Área 404' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM Sala WHERE nomeSala = 'Arranha-céu Digital');

INSERT INTO Sala (nomeSala, fk_regiao)
SELECT 'SkyBar Holográfico', (SELECT idRegiao FROM Regiao WHERE nomeRegiao = 'Área 404' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM Sala WHERE nomeSala = 'SkyBar Holográfico');

INSERT INTO Sala (nomeSala, fk_regiao)
SELECT 'Laboratório de IA', (SELECT idRegiao FROM Regiao WHERE nomeRegiao = 'Área 404' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM Sala WHERE nomeSala = 'Laboratório de IA');

INSERT INTO Sala (nomeSala, fk_regiao)
SELECT 'Arcádia Hacker', (SELECT idRegiao FROM Regiao WHERE nomeRegiao = 'Área 404' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM Sala WHERE nomeSala = 'Arcádia Hacker');

INSERT INTO Sala (nomeSala, fk_regiao)
SELECT 'Avenida Luminosa', (SELECT idRegiao FROM Regiao WHERE nomeRegiao = 'Área 404' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM Sala WHERE nomeSala = 'Avenida Luminosa');

INSERT INTO Sala (nomeSala, fk_regiao)
SELECT 'Cofre Quântico', (SELECT idRegiao FROM Regiao WHERE nomeRegiao = 'Área 404' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM Sala WHERE nomeSala = 'Cofre Quântico');

INSERT INTO Sala (nomeSala, fk_regiao)
SELECT 'Hangar de Drones', (SELECT idRegiao FROM Regiao WHERE nomeRegiao = 'Área 404' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM Sala WHERE nomeSala = 'Hangar de Drones');

INSERT INTO Sala (nomeSala, fk_regiao)
SELECT 'Fortaleza Virtual', (SELECT idRegiao FROM Regiao WHERE nomeRegiao = 'Área 404' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM Sala WHERE nomeSala = 'Fortaleza Virtual');

INSERT INTO Sala (nomeSala, fk_regiao)
SELECT 'Bairro Exilado', (SELECT idRegiao FROM Regiao WHERE nomeRegiao = 'Área 404' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM Sala WHERE nomeSala = 'Bairro Exilado');

INSERT INTO Sala (nomeSala, fk_regiao)
SELECT 'Porto de Dados', (SELECT idRegiao FROM Regiao WHERE nomeRegiao = 'Área 404' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM Sala WHERE nomeSala = 'Porto de Dados');

INSERT INTO Sala (nomeSala, fk_regiao)
SELECT 'Templo Cibernético', (SELECT idRegiao FROM Regiao WHERE nomeRegiao = 'Área 404' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM Sala WHERE nomeSala = 'Templo Cibernético');

UPDATE Sala SET leste = 2 WHERE idSala = 1 AND leste IS NULL;
UPDATE Sala SET oeste = 1, norte = 3, leste = 4 WHERE idSala = 2 AND (oeste IS NULL OR norte IS NULL OR leste IS NULL);
UPDATE Sala SET sul = 2, leste = 5 WHERE idSala = 3 AND (sul IS NULL OR leste IS NULL);
UPDATE Sala SET oeste = 2, norte = 6 WHERE idSala = 4 AND (oeste IS NULL OR norte IS NULL);
UPDATE Sala SET oeste = 3, leste = 7 WHERE idSala = 5 AND (oeste IS NULL OR leste IS NULL);
UPDATE Sala SET sul = 4, leste = 8 WHERE idSala = 6 AND (sul IS NULL OR leste IS NULL);
UPDATE Sala SET oeste = 5, norte = 9 WHERE idSala = 7 AND (oeste IS NULL OR norte IS NULL);
UPDATE Sala SET oeste = 6, sul = 10 WHERE idSala = 8 AND (oeste IS NULL OR sul IS NULL);
UPDATE Sala SET sul = 7, leste = 11 WHERE idSala = 9 AND (sul IS NULL OR leste IS NULL);
UPDATE Sala SET norte = 8, leste = 12 WHERE idSala = 10 AND (norte IS NULL OR leste IS NULL);
UPDATE Sala SET oeste = 9 WHERE idSala = 11 AND oeste IS NULL;
UPDATE Sala SET oeste = 10 WHERE idSala = 12 AND oeste IS NULL;

UPDATE Sala SET leste = 14 WHERE idSala = 13 AND leste IS NULL;
UPDATE Sala SET oeste = 13, norte = 15, leste = 16 WHERE idSala = 14 AND (oeste IS NULL OR norte IS NULL OR leste IS NULL);
UPDATE Sala SET sul = 14, leste = 17 WHERE idSala = 15 AND (sul IS NULL OR leste IS NULL);
UPDATE Sala SET oeste = 14, norte = 18 WHERE idSala = 16 AND (oeste IS NULL OR norte IS NULL);
UPDATE Sala SET oeste = 15, leste = 19 WHERE idSala = 17 AND (oeste IS NULL OR leste IS NULL);
UPDATE Sala SET sul = 16, leste = 20 WHERE idSala = 18 AND (sul IS NULL OR leste IS NULL);
UPDATE Sala SET oeste = 17, norte = 21 WHERE idSala = 19 AND (oeste IS NULL OR norte IS NULL);
UPDATE Sala SET oeste = 18, sul = 22 WHERE idSala = 20 AND (oeste IS NULL OR sul IS NULL);
UPDATE Sala SET sul = 19, leste = 23 WHERE idSala = 21 AND (sul IS NULL OR leste IS NULL);
UPDATE Sala SET norte = 20, leste = 24 WHERE idSala = 22 AND (norte IS NULL OR leste IS NULL);
UPDATE Sala SET oeste = 21 WHERE idSala = 23 AND oeste IS NULL;
UPDATE Sala SET oeste = 22 WHERE idSala = 24 AND oeste IS NULL;

-- SALA DE PARA JOGAR OS INIMIGOS.
INSERT INTO Sala (nomeSala, fk_regiao)
SELECT 'Cemiterio Digital', (SELECT idRegiao FROM Regiao WHERE nomeRegiao = 'Darknet Town' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM Sala WHERE nomeSala = 'Cemiterio Digital');