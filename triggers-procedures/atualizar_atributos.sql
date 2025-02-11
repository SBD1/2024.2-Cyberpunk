CREATE OR REPLACE FUNCTION atualizar_atributos_cyberlutador(idCyberLutador INT, nomeNPC TEXT)
RETURNS VOID AS $$
DECLARE
    aumentainteligencia INT;
    aumentafurtividade INT;
    aumentapercepcao INT;
BEGIN
    SELECT aumentaInteligencia, aumentaFurtividade, aumentaPercepcao
    INTO aumentainteligencia, aumentafurtividade, aumentapercepcao
    FROM Mentor
    WHERE fk_npc = (SELECT idNPC FROM NPC WHERE nomeNPC = nomeNPC)
    LIMIT 1;

    IF aumentainteligencia IS NULL OR aumentafurtividade IS NULL OR aumentapercepcao IS NULL THEN
        RAISE NOTICE 'Nenhum mentor encontrado para o NPC %.', nomeNPC;
        RETURN;
    END IF;

    UPDATE CyberLutador
    SET inteligencia = inteligencia + COALESCE(aumentainteligencia, 0),
        furtividade = furtividade + COALESCE(aumentafurtividade, 0),
        percepcao = percepcao + COALESCE(aumentapercepcao, 0)
    WHERE idCyberLutador = idCyberLutador;

    RAISE NOTICE 'Atributos atualizados com sucesso para CyberLutador %.', idCyberLutador;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION trigger_atualizar_atributos()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM atualizar_atributos_cyberlutador(NEW.idCyberLutador, NEW.nomeNPC);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_atualizar_atributos
AFTER INSERT ON CyberLutador
FOR EACH ROW
EXECUTE FUNCTION trigger_atualizar_atributos();
