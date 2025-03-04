DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'mochila' AND column_name = 'dinheiro') THEN
        ALTER TABLE Mochila ADD COLUMN dinheiro INT DEFAULT 0;
    END IF;
END $$;

DROP TRIGGER IF EXISTS recompensa_normal_trigger ON InstanciaInimigo;
DROP TRIGGER IF EXISTS recompensa_missao_trigger ON Missao;
DROP TRIGGER IF EXISTS comprar_item_trigger ON Mercado_Item;
DROP TRIGGER IF EXISTS criar_mochila_trigger ON CyberLutador;
DROP TRIGGER IF EXISTS inserirItensIniciais_trigger ON Mochila;

DROP FUNCTION IF EXISTS recompensa_normal();
DROP FUNCTION IF EXISTS recompensa_missao();
DROP FUNCTION IF EXISTS comprar_item();
DROP FUNCTION IF EXISTS criar_mochila();
DROP FUNCTION IF EXISTS inserirItensIniciais();

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

-- Criar trigger para recompensa_normal
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

-- Criar trigger para recompensa_missao
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

-- Criar trigger para comprar_item
CREATE TRIGGER comprar_item_trigger
BEFORE UPDATE ON Mercado_Item
FOR EACH ROW EXECUTE FUNCTION comprar_item();

CREATE FUNCTION criar_mochila() RETURNS TRIGGER AS $criar_mochila$
DECLARE
    nova_mochila_id INT;
BEGIN
    INSERT INTO Mochila (capacidade, fk_cyberlutador, fk_instanciaitem)
    VALUES (20, NEW.idCyberLutador, 1);
    
    RETURN NEW;
END;
$criar_mochila$ LANGUAGE plpgsql;

-- Criar trigger para criar_mochila
CREATE TRIGGER criar_mochila_trigger
AFTER INSERT ON CyberLutador
FOR EACH ROW EXECUTE FUNCTION criar_mochila();

CREATE FUNCTION inserirItensIniciais() RETURNS TRIGGER AS $inserirItensIniciais$
BEGIN
    INSERT INTO Mochila_Item (fk_mochila, fk_instanciaitem)
    SELECT NEW.idMochila, ii.idInstanciaItem  -- Ajuste a quantidade conforme necessário
    FROM InstanciaItem ii;
    
    RETURN NEW;
END;
$inserirItensIniciais$ LANGUAGE plpgsql;

-- Criar trigger parainserirItensIniciais
CREATE TRIGGER inserirItensIniciais_trigger
AFTER INSERT ON Mochila
FOR EACH ROW EXECUTE FUNCTION inserirItensIniciais();