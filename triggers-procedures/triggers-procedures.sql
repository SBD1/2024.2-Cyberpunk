ALTER TABLE Mochila ADD COLUMN dinheiro INT DEFAULT 0;

CREATE FUNCTION recompensa_normal() RETURNS TRIGGER AS $recompensa_normal$
BEGIN
    DECLARE
        valor_recompensa INT;
    BEGIN
        SELECT valor INTO valor_recompensa
        FROM Recompensa
        WHERE idInstanciaInimigo = OLD.idInstanciaInimigo;

        IF valor_recompensa IS NULL THEN
            valor_recompensa := 0; 
        END IF;

        UPDATE Mochila
        SET dinheiro = dinheiro + valor_recompensa
        WHERE fk_cyberlutador = OLD.idCyberLutador;

        RETURN NEW;
    END;
END;
$recompensa_normal$ LANGUAGE plpgsql;

CREATE TRIGGER recompensa_normal_trigger
BEFORE DELETE ON InstanciaInimigo
FOR EACH ROW EXECUTE FUNCTION recompensa_normal();


CREATE FUNCTION recompensa_missao() RETURNS TRIGGER AS $recompensa_missao$
BEGIN
    DECLARE
        valor_recompensa INT;
    BEGIN
        IF NEW.progresso = 'COMPLETA' THEN
            UPDATE Mochila
            SET dinheiro = dinheiro + 50
            WHERE fk_cyberlutador = NEW.fk_cyberlutador;     
        END IF;

        RETURN NEW;
    END;
END;
$recompensa_missao$ LANGUAGE plpgsql;

CREATE TRIGGER recompensa_missao_trigger
AFTER UPDATE ON Missao
FOR EACH ROW EXECUTE FUNCTION recompensa_missao();

CREATE FUNCTION comprar_item() RETURNS TRIGGER AS $comprar_item$
BEGIN
    DECLARE
        valor_item INT;
    BEGIN
        SELECT valor INTO valor_item
        FROM Item i
        JOIN InstanciaItem ii ON idInstanciaItem = NEW.fk_instanciaitem
        WHERE idItem = NEW.fk_iditem;

        UPDATE Mochila
        SET dinheiro = dinheiro - valor_item
        WHERE fk_cyberlutador = NEW.fk_cyberlutador;

        IF (dinheiro < 0) THEN
            RAISE EXCEPTION 'Não há dinheiro suficiente para comprar o item';
        END IF;

        RETURN NEW;
    END;
END;

$comprar_item$ LANGUAGE plpgsql;

CREATE TRIGGER comprar_item_trigger
BEFORE UPDATE ON Mercado_Item
FOR EACH ROW EXECUTE FUNCTION comprar_item();