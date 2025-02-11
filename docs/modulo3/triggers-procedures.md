# Introdução

<p align="justify">
Triggers e Stored Procedures são elementos essenciais ao banco de dados quando se diz à respeito de promover sua estabilidade e configuração correta mediante à possibilidades que não são inicialmente garantidas pelo próprio SQL. Como exemplo, situações em que se desejaria atualizar a informação de uma tabela, mediante alteração em outras, ou até garantir que a especialização e/ou generalização esteja de acordo com o previsto pelas entidades e relacionamentos de um projeto. 
</p>

# Procedures

<p align="justify">
Procedures irão trazer "funções" ao banco de dados, permitindo uma execução sequencial de instruções, que podem ou não incluir condicionais, que auxiliam a executar uma sequência de ações diante de um objetivo final, como, por exemplo, inserir uma nova tupla em uma tabela, retirando a possibilidade de que um usuário externo apresente informações erradas (como um id já existente) ou ainda atualizar uma tabela de controle cujo usuário não deveria ter acesso justamente para que seja possível manter a estabilidade do banco de dados.

</p>

# Triggers
<p align="justify">
Triggers são "gatilhos" propriamente ditos, que são ativados mediante uma condição fixa que ocorre no banco de dados. Essa condição fixa se dá através de instruções DML (INSERT, UPDATE, DELETE) e podem ser ativados tanto antes (BEFORE) quanto depois (AFTER) da instrução DML que o condiciona. Através do gatilho então ativado, um procedure é automaticamente executado, sem a necessidade de fazer seu chamado ou executá-lo manualmente. Através dessa operação automática, pode-se impedir que certas ações que poderiam invalidar os dados sejam executadas, ou ainda atualizar alguma nova tabela e ou informação que tenha sua dependência no DML em questão. No caso do nosso projeto, podemos exemplificar com a compra de itens, sendo que caso o jogador não tenha "dinheiro" suficiente, ao tentar comprar um item na loja, o mesmo seria recebido com um "EXCEPTION", assim cancelando a compra e retornando para ele o problema.   
</p>

## Compra de um Item em um Mercado Clandestino:

```sql
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

```
<p align="justify">
Com a criação do trigger, em vez de utilizarmos uma lógica de verificação a cada item, em cada loja, podemos realizar a checagem e atualização de diversos dados a partir da ação de tentar comprar um item. Neste caso, na situação em que o jogador não possuir "dinheiro" para comprar o item, o banco de dados irá retornar um erro e a operação de compra é cancelada.
</p>

## Atualizar atributos do CyberLutador:

```sql
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

```

<p align="justify">
Este trigger chama um procedure para atulizar os atributos do CyberLutador, como inteligência e furtividade, quando ele interage com um NPC Mentor.
</p>

## Move o inimigo para o cemitério digital:

```sql
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

```

<p align="justify">
Esse procedure move a instancia do inimigo para o cemitério dgital quando ele perde uma batalha par ao cyberlutrador.
</p>

## Reseta o jogador para a sala padrão:

```sql
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

```

<p align="justify">
Este procedure move o cyberlutador para a salão padrão 'laboratório' e reseta sua vida, quando ele perde uma batalha para o inimigo.
</p>

## Histórico de versões

| Versão |  Data  | Descrição | Autor | 
|:------:|:------:|:---------:|------:|
| 1.0 | 03/02/2025 | Criação e escrita | [Lucas Meireles](https://github.com/Katuner) |
| 1.1 | 03/02/2025 | Atualização de exemplo | [Lucas Meireles](https://github.com/Katuner) |
| 1.4 | 10/02/2025 | Inserção de novos triggers e procedures | [Gabrielly Assuncao](https://github.com/GabriellyAssuncao) |

