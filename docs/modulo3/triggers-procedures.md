# Introdução

<p align="justify">
Triggers e Stored Procedures são elementos essenciais ao banco de dados quando se diz à respeito de promover sua estabilidade e configuração correta mediante à possibilidades que não são inicialmente garantidas pelo próprio SQL. Como exemplo, situações em que se desejaria atualizar a informação de uma tabela, mediante alteração em outras, ou até garantir que a especialização e/ou generalização esteja de acordo com o previsto pelas entidades e relacionamentos de um projeto. 
</p>

# Procedures

<p align="justify">
Procedures irão trazer "funções" ao banco de dados, permitindo uma execução sequencial de instruções, que podem ou não incluir condicionais, que auxiliam a executar uma sequência de ações diante de um objetivo final, como, por exemplo, inserir uma nova tupla em uma tabela, retirando a possibilidade de que um usuário externo apresente informações erradas (como um id já existente) ou ainda atualizar uma tabela de controle cujo usuário não deveria ter acesso justamente para que seja possível manter a estabilidade do banco de dados.

Exemplos podem ser encontrados em [[PREENCHER COM ARQUIVO E DIRECTORY]]
</p>

# Triggers

<p align="justify">
Triggers são "gatilhos" propriamente ditos, que são ativados mediante uma condição fixa que ocorre no banco de dados. Essa condição fixa se dá através de instruções DML (INSERT, UPDATE, DELETE) e podem ser ativados tanto antes (BEFORE) quanto depois (AFTER) da instrução DML que o condiciona. Através do gatilho então ativado, um procedure é automaticamente executado, sem a necessidade de fazer seu chamado ou executá-lo manualmente. Através dessa operação automática, pode-se impedir que certas ações que poderiam invalidar os dados sejam executadas, ou ainda atualizar alguma nova tabela e ou informação que tenha sua dependência no DML em questão. No caso do nosso projeto, podemos exemplificar com a compra de itens, sendo que caso o jogador não tenha "dinheiro" suficiente, ao tentar comprar um item na loja, o mesmo seria recebido com um "EXCEPTION", assim cancelando a compra e retornando para ele o problema.

Exemplos podem ser encontrados em [[PREENCHER COM ARQUIVO E DIRECTORY]]
</p>

## Histórico de versões

| Versão |  Data  | Descrição | Autor | 
|:------:|:------:|:---------:|------:|
| 1.0 | 03/02/2025 | Criação e escrita | [Lucas Meireles](https://github.com/Katuner) |
