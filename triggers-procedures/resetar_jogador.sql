CREATE OR REPLACE FUNCTION resetar_jogador(idCyberLutador INT) RETURNS VOID AS $$
DECLARE
    idLaboratorio INT;
BEGIN
    SELECT idSala INTO idLaboratorio FROM Sala WHERE nomeSala = 'Laboratorio';
    
    IF idLaboratorio IS NULL THEN
        RAISE EXCEPTION 'Laboratório não encontrado';
    END IF;
    
    UPDATE CyberLutador 
    SET vida = 10, fk_sala_atual = idLaboratorio
    WHERE idCyberLutador = idCyberLutador;
    
    RAISE NOTICE 'Jogador resetado no Laboratório com vida cheia';
END;
$$ LANGUAGE plpgsql;
