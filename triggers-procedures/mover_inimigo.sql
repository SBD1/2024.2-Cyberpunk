CREATE OR REPLACE FUNCTION mover_inimigo_para_cemiterio(idInstanciaInimigo INT) RETURNS VOID AS $$
DECLARE
    idSalaCemiterio INT;
BEGIN
    SELECT idSala INTO idSalaCemiterio FROM Sala WHERE nomeSala = 'Cemiterio Digital';
    
    IF idSalaCemiterio IS NULL THEN
        RAISE EXCEPTION 'Cemitério Digital não encontrado';
    END IF;
    
    UPDATE NPC 
    SET fk_sala = idSalaCemiterio 
    WHERE idNPC = (
        SELECT i.fk_npc 
        FROM InstanciaInimigo ii
        JOIN Inimigo i ON ii.fk_inimigo = i.idInimigo
        WHERE ii.idInstanciaInimigo = idInstanciaInimigo
    );

    RAISE NOTICE 'Inimigo movido para o Cemitério Digital';
END;
$$ LANGUAGE plpgsql;
