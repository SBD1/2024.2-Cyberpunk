DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'mochila' AND column_name = 'dinheiro') THEN
        ALTER TABLE Mochila ADD COLUMN dinheiro INT DEFAULT 0;
    END IF;
END $$;

CREATE FUNCTION recompensa_normal() RETURNS TRIGGER AS $recompensa_normal$
DECLARE
    valor_recompensa INT;
BEGIN

    SELECT valor INTO valor_recompensa
    FROM Recompensa
    WHERE fk_instancia_inimigo = OLD.idInstanciaInimigo;

    IF valor_recompensa IS NULL THEN
        valor_recompensa := 0; 
    END IF;

    UPDATE Mochila
    SET dinheiro = dinheiro + valor_recompensa
    WHERE fk_cyberlutador = OLD.fk_cyberlutador;

    RETURN OLD;
END;
$recompensa_normal$ LANGUAGE plpgsql;

CREATE TRIGGER recompensa_normal_trigger
BEFORE DELETE ON InstanciaInimigo
FOR EACH ROW EXECUTE FUNCTION recompensa_normal();



CREATE FUNCTION recompensa_missao() RETURNS TRIGGER AS $recompensa_missao$
BEGIN
    IF NEW.progresso = 'COMPLETA' AND OLD.progresso <> 'COMPLETA' THEN
        UPDATE Mochila
        SET dinheiro = dinheiro + 50
        WHERE fk_cyberlutador = NEW.fk_cyberlutador;     
    END IF;

    RETURN NEW;
END;
$recompensa_missao$ LANGUAGE plpgsql;

CREATE TRIGGER recompensa_missao_trigger
AFTER UPDATE ON Missao
FOR EACH ROW EXECUTE FUNCTION recompensa_missao();


CREATE FUNCTION comprar_item() RETURNS TRIGGER AS $comprar_item$
DECLARE
    valor_item INT;
    saldo_atual INT;
BEGIN
    SELECT i.valor INTO valor_item
    FROM Item i
    JOIN InstanciaItem ii ON ii.fk_item = i.idItem
    WHERE ii.idInstanciaItem = NEW.fk_instanciaitem;

    SELECT dinheiro INTO saldo_atual
    FROM Mochila
    WHERE fk_cyberlutador = NEW.fk_cyberlutador;

    IF saldo_atual < valor_item THEN
        RAISE EXCEPTION 'Não há dinheiro suficiente para comprar o item';
    END IF;

    UPDATE Mochila
    SET dinheiro = dinheiro - valor_item
    WHERE fk_cyberlutador = NEW.fk_cyberlutador;

    RETURN NEW;
END;
$comprar_item$ LANGUAGE plpgsql;

-- Criando o trigger
CREATE TRIGGER comprar_item_trigger
BEFORE UPDATE ON Mercado_Item
FOR EACH ROW EXECUTE FUNCTION comprar_item();