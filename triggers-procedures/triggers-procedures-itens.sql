
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
$equipar_item$ LANGUAGE plpgsql;

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
$desequipar_item$ LANGUAGE plpgsql;

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
$guardar_item$ LANGUAGE plpgsql;

-- Criar trigger para guardar_item
CREATE TRIGGER guardar_item_trigger
AFTER UPDATE ON InstanciaItem
FOR EACH ROW WHEN (NEW.fk_cyberlutador IS NOT NULL) EXECUTE FUNCTION guardar_item();