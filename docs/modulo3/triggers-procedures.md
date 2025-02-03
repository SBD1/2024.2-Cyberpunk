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
## Exemplo de Trigger para a Compra de um Item em um Mercado Clandestino:

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

Com a criação do trigger, em vez de utilizarmos uma lógica de verificação a cada item, em cada loja, podemos realizar a checagem e atualização de diversos dados a partir da ação de tentar comprar um item. Neste caso, na situação em que o jogador não possuir "dinheiro" para comprar o item, o banco de dados irá retornar um erro e a operação de compra é cancelada.

Outros triggers e procedures podem ser encontrados em <a href="https://github.com/SBD1/2024.2-Cyberpunk/tree/699fca42dff077014855068d58069e5214081bae/triggers-procedures" target="blank"> Triggers & Stored Procedures </a>

## Histórico de versões

| Versão |  Data  | Descrição | Autor | 
|:------:|:------:|:---------:|------:|
| 1.0 | 03/02/2025 | Criação e escrita | [Lucas Meireles](https://github.com/Katuner) |
| 1.1 | 03/02/2025 | Atualização de exemplo | [Lucas Meireles](https://github.com/Katuner) |
