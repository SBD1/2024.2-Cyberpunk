INSERT INTO Regiao(nomeRegiao)
VALUES
('Região 1');

INSERT INTO Sala (nomeSala, fk_regiao)
VALUES
('Laboratório', 1),
('Ruínas', 1),
('Distrito Neon', 1);

UPDATE Sala SET leste = 2 WHERE idSala = 1;
UPDATE Sala SET oeste = 1, norte = 3 WHERE idSala = 2;
UPDATE Sala SET sul = 2 WHERE idSala = 3;