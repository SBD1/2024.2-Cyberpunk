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

DROP FUNCTION IF EXISTS recompensa_normal();
DROP FUNCTION IF EXISTS recompensa_missao();
DROP FUNCTION IF EXISTS comprar_item();
DROP FUNCTION IF EXISTS criar_mochila();

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


CREATE OR REPLACE FUNCTION criar_mochila() RETURNS TRIGGER AS $criar_mochila$
DECLARE
    nova_mochila_id INT;
BEGIN
    INSERT INTO Mochila (capacidade, fk_cyberlutador)
    VALUES (20, NEW.idCyberLutador);
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criar trigger para criar_mochila
CREATE TRIGGER criar_mochila_trigger
AFTER INSERT ON CyberLutador
FOR EACH ROW EXECUTE criar_mochila();


CREATE OR REPLACE FUNCTION equipar_item() RETURNS TRIGGER AS $equipar_item$
DECLARE
    aumento_forca INT := 0;
    aumento_velocidade INT := 0;
    aumento_inteligencia INT := 0;
    aumento_resistencia INT := 0;
    aumento_furtividade INT := 0;
    aumento_percepcao INT := 0;
    aumento_vida INT := 0;
BEGIN
    -- Verificar se é um Biochip
    SELECT regeneraVida INTO aumento_vida
    FROM Biochip WHERE fk_item = NEW.fk_item;

    -- Verificar se é um Implante e quais atributos ele aumenta
    SELECT aumentaForca, aumentaVeloc INTO aumento_forca, aumento_velocidade
    FROM BracoRobotico WHERE fk_implante = (SELECT idImplante FROM Implante WHERE fk_item = NEW.fk_item);
    
    SELECT aumentaInt, aumentaResis INTO aumento_inteligencia, aumento_resistencia
    FROM CapaceteNeural WHERE fk_implante = (SELECT idImplante FROM Implante WHERE fk_item = NEW.fk_item);
    
    SELECT aumentaFurti, aumentaPercep INTO aumento_furtividade, aumento_percepcao
    FROM VisaoCibernetica WHERE fk_implante = (SELECT idImplante FROM Implante WHERE fk_item = NEW.fk_item);

    -- Atualizar os atributos do CyberLutador
    UPDATE CyberLutador
    SET 
        forca = forca + COALESCE(aumento_forca, 0),
        velocidade = velocidade + COALESCE(aumento_velocidade, 0),
        inteligencia = inteligencia + COALESCE(aumento_inteligencia, 0),
        resistencia = resistencia + COALESCE(aumento_resistencia, 0),
        furtividade = furtividade + COALESCE(aumento_furtividade, 0),
        percepcao = percepcao + COALESCE(aumento_percepcao, 0),
        vida = vida + COALESCE(aumento_vida, 0)
    WHERE idCyberLutador = NEW.fk_cyberlutador;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criar trigger para equipar_item
CREATE TRIGGER equipar_item_trigger
AFTER INSERT ON InstanciaItem
FOR EACH ROW WHEN (NEW.fk_cyberlutador IS NOT NULL) EXECUTE FUNCTION equipar_item();


CREATE OR REPLACE FUNCTION desequipar_item() RETURNS TRIGGER AS $desequipar_item$
DECLARE
    aumento_forca INT := 0;
    aumento_velocidade INT := 0;
    aumento_inteligencia INT := 0;
    aumento_resistencia INT := 0;
    aumento_furtividade INT := 0;
    aumento_percepcao INT := 0;
    aumento_vida INT := 0;
    id_mochila INT;
BEGIN
    -- Verificar se é um Biochip
    SELECT regeneraVida INTO aumento_vida
    FROM Biochip WHERE fk_item = OLD.fk_item;

    -- Verificar se é um Implante e quais atributos ele aumenta
    SELECT aumentaForca, aumentaVeloc INTO aumento_forca, aumento_velocidade
    FROM BracoRobotico WHERE fk_implante = (SELECT idImplante FROM Implante WHERE fk_item = OLD.fk_item);
    
    SELECT aumentaInt, aumentaResis INTO aumento_inteligencia, aumento_resistencia
    FROM CapaceteNeural WHERE fk_implante = (SELECT idImplante FROM Implante WHERE fk_item = OLD.fk_item);
    
    SELECT aumentaFurti, aumentaPercep INTO aumento_furtividade, aumento_percepcao
    FROM VisaoCibernetica WHERE fk_implante = (SELECT idImplante FROM Implante WHERE fk_item = OLD.fk_item);

    -- Atualizar os atributos do CyberLutador removendo os aumentos
    UPDATE CyberLutador
    SET 
        forca = forca - COALESCE(aumento_forca, 0),
        velocidade = velocidade - COALESCE(aumento_velocidade, 0),
        inteligencia = inteligencia - COALESCE(aumento_inteligencia, 0),
        resistencia = resistencia - COALESCE(aumento_resistencia, 0),
        furtividade = furtividade - COALESCE(aumento_furtividade, 0),
        percepcao = percepcao - COALESCE(aumento_percepcao, 0),
        vida = vida - COALESCE(aumento_vida, 0)
    WHERE idCyberLutador = OLD.fk_cyberlutador;

    -- Obter a id da mochila do CyberLutador
    SELECT m.idMochila INTO id_mochila
    FROM Mochila m
    WHERE m.fk_cyberlutador = OLD.fk_cyberlutador;

    -- Mover o item para a mochila (adicionar idMochila ao item)
    UPDATE InstanciaItem
    SET fk_mochila = id_mochila  -- Atualiza a instância do item com o id da mochila
    WHERE idInstanciaItem = OLD.idInstanciaItem;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Criar trigger para desequipar_item
CREATE TRIGGER desequipar_item_trigger
AFTER UPDATE ON InstanciaItem
FOR EACH ROW WHEN (OLD.fk_cyberlutador IS NOT NULL AND NEW.fk_cyberlutador IS NULL)
EXECUTE FUNCTION desequipar_item();



CREATE OR REPLACE FUNCTION guardar_item() RETURNS TRIGGER AS $guardar_item$
DECLARE
    id_mochila INT;
BEGIN
    -- Obter o id da mochila do CyberLutador
    SELECT m.idMochila INTO id_mochila
    FROM Mochila m
    WHERE m.fk_cyberlutador = NEW.fk_cyberlutador;

    -- Atualizar a instância do item, associando à mochila e deixando o campo fk_cyberlutador como NULL
    UPDATE InstanciaItem
    SET fk_mochila = id_mochila, fk_cyberlutador = NULL
    WHERE idInstanciaItem = NEW.idInstanciaItem;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criar trigger para guardar_item
CREATE TRIGGER guardar_item_trigger
AFTER UPDATE ON InstanciaItem
FOR EACH ROW WHEN (NEW.fk_cyberlutador IS NOT NULL) EXECUTE FUNCTION guardar_item();