# Introdução

<p align="justify">
A modelagem conceitual é uma etapa fundamental no processo de desenvolvimento de sistemas de banco de dados. Essa fase visa representar as estruturas e restrições de forma abstrata, proporcionando uma visão clara e compreensível dos requisitos do sistema antes de sua implementação. Essa abordagem auxilia na identificação de problemas e inconsistências iniciais, evitando retrabalho em etapas posteriores.
</p>

<p align="justify">
Entre os métodos de modelagem conceitual, o Modelo Entidade-Relacionamento (MER) se destaca como uma das ferramentas mais amplamente utilizadas. O MER permite a representação gráfica de entidades, atributos e relacionamentos, estabelecendo uma base sólida para a construção de um banco de dados lógico e físico. Sua importância reside na capacidade de comunicar, de forma intuitiva, a estrutura e os relacionamentos do sistema tanto para especialistas técnicos quanto para usuários finais.
</p>

# Objetivo

Este documento tem como propósito descrever, de maneira detalhada, as entidades, atributos e relacionamentos identificados no sistema, utilizando o Modelo Entidade-Relacionamento como base. A visualização gráfica resultante do MER será representada no Diagrama Entidade-Relacionamento (DER), servindo como referência principal para o desenvolvimento subsequente do banco de dados.

# Modelo Entidade Relacionamento

## Entidades

* **EXOHUMANO**
    * **NPC**
    * **CYBERLUTADOR**
        * **INIMIGO**
        * **INSTANCIAINIMIGO**
        * **PLAYER**
* **MOCHILA**
* **INSTANCIAITEM**
* **ITEM**
    * **COMPONENTE**
    * **BIOCHIP**
        * **CHIPCURA**
        * **CHIPADRENALINA**
    * **ITEMCHAVE**
* **IMPLANTE**
    * **BRACOROBOTICO**
    * **CAPACETENEURAL**
    * **VISAOCIBERNETICA**
* **MERCADOCLANDESTINO**
* **MISSÃO**
* **SALA**
* **REGIÃO**
* **MAPA**
* **PUZZLE**
    * **DECODIFICAR**
    * **MATEMATICO**
* **CARRO**

## Atributos

* **EXOHUMANO**: <u>idExoHumano</u>, nome
    * **NPC**: <u>idNPC</u>
    * **CYBERLUTADOR**: velocidade, vida, inteligência, furtividade, percepção, resistência
        * **INIMIGO**: <u>idInimigo</u>
        * **PLAYER**: <u>idPlayer</u>
* **MOCHILA**: <u>idInventario</u>, capacidade, itemArmazenado
* **ITEM**: <u>idItem</u>, nomeItem, valor, descricao
    * **COMPONENTE**: 
    * **BIOCHIP**
        * **CHIPCURA**
        * **CHIPADRENALINA**
    * **ITEMCHAVE**
* **IMPLANTE**: <u>idImplante</u>, nomeImplante, tipo, localInstalação, upgrade
    * **BRACOROBOTICO**
    * **CAPACETENEURAL**
    * **VISAOCIBERNETICA**
* **MERCADOCLANDESTINO**: <u>idLoja</u>, nomeLoja, produtoFornecido
* **MISSÃO**: <u>idMissao</u>, nomeMissao, objetivo, recompensa, itensNecessario
* **SALA**: <u>idSala</u>, nomeSala
* **REGIÃO**: <u>idRegiao</u>, nomeRegiao
* **MAPA**: <u>idMapa</u>, nomeMapa
* **PUZZLE**: <u>idPuzzle</u>, nomePuzzle, dificuldade
    * **DECODIFICAR**
    * **MATEMATICO**
* **CARRO**: <u>idCarro</u>, capacidade, velocidade, combustivel, preco, conservacao, nivelSeguranca, blindagem

## Relacionamentos
 <br>
EXOHUMANO - participa - MISSÃO <br>
* EXOHUMANO participa de zero ou várias MISSÕES (0,N) <br>
* MISSÃO tem a participação de um unico EXOHUMANO (1,1) <br>

EXOHUMANO - possui - DIALOGO <br>
* EXOHUMANO possui zero ou vários DIALOGOS (0,N) <br>
* DIALOGO é possuido por um unico EXOHUMANO (1,1) <br>

EXOHUMANO - esta - SALA <br>
* Varios EXOHUMANOS estão em varias SALAS (N,M) <br>
* SALA pode estar com zero ou varios EXOHUMANOS (0,N) <br>

EXOHUMANO - participa - FACCAO <br>
* EXOHUMANO participa de uma unica FACÇÃO (1,1) <br>
* FACÇÃO tem a participação de zero ou vários EXOHUMANOS (0,N) <br>

NPC - possui - MERCADOCLANDESTINO <br>
* NPC possui zero ou um MERCADOCLANDESTINO (0,1) <br>
* MERCADOCLANDESTINO é possuido por um unico NPC (1,1) <br>

MERCADOCLANDESTINO - possui - CARRO <br>
* MERCADOCLANDESTINO possui zero ou vários CARROS (0,N) <br>
* CARRO é possuido por um único MERCADOCLANDESTINO (1,1) <br>

MERCADOCLANDESTINO - vende - ITEM <br>
* MERCADOCLANDESTINO vende um ou varios ITENS (1,N) <br>
* ITEM é vendido por zero ou varios MERCADOCLANDESTINOS (0,N) <br>

PLAYER - acessa - MERCADOCLANDESTINO <br>
* PLAYER acessa zero ou varios MERCADOCLANDESTINOS (0,N) <br>
* MERCADOCLANDESTINO pode ser acessado por zero ou um unico PLAYER (0,1) <br>

PLAYER - utiliza - CARRO <br>
* PLAYER utiliza zero ou um CARRO (0,1) <br>
* CARRO é utilizado por zero ou um PLAYER (0,1) <br>

PLAYER - resolve - PUZZLE <br>
* PLAYER resolve zero ou um PUZZLE (0,1) <br>
* PUZZLE é resolvido por zero ou um PLAYER (0,1) <br>

CARRO - esta - REGIÃO  <br>
* CARRO esta em uma única REGIÃO (1,1) <br>
* REGIÃO pode estar com zero ou vários CARROS (0,N) <br>

REGIÃO - esta - MAPA <br>
* REGIÃO esta em um único MAPA (1,1) <br>
* MAPA pode estar com um ou várias REGIÕES (1,N) <br>

SALA - esta - REGIÃO <br>
* SALA esta em uma ou várias REGIÕES (1,N) <br>
* REGIÃO pode estar com zero ou várias SALAS (0,N) <br>

SALA - conecta - SALA <br>
* SALA conecta em uma ou seis SALAS (1,6) <br>
* SALA é conectada por uma ou seis SALA (1,6) <br>

PUZZLE - esta - MISSÃO <br>
* PUZZLE esta em zero ou várias MISSÕES (0,N) <br>
* MISSÃO pode estar com zero ou varios PUZZLES (0,N) <br>

PLAYER - enfrente - INSTANCIAINIMIGO <br>
* PLAYER enfrenta uma ou várias INSTANCIAINIMIGO (1,N) <br>
* INSTANCIAINIMIGO é enfrentado por um único PLAYER (1,1) <br>

Inimigo - gera - INSTANCIAINIMIGO <br>
* Inimigo gera uma ou várias InstanciasInimigo (1,N) <br>
* INSTANCIAINIMIGO é gerado por um único Inimio (1,1) <br>

CYBERLUTADOR - possui - MOCHILA <br>
* CYBERLUTADOR possui uma ou várias MOCHILAS (1,N) <br>
* MOCHILA é possuída por um único CYBERLUTADOR (1,1) <br>

CYBERLUTADOR - utiliza - IMPLANTE  <br>
* CYBERLUTADOR utiliza zero ou vários IMPLANTES (0,N) <br>
* IMPLANTE é utilizado por zero ou vários CYBERLUTADOR (0,N) <br>

MOCHILA - possui - INSTANCIAITEM <br>
* MOCHILA possui zero ou várias INSTANCIAITEM (0,N) <br>
* INSTANCIAITEM é possuída por zero ou várias MOCHILAS (0,N) <br>

ITEM - gera - INSTANCIAITEM <br>
* ITEM gera um ou várias INSTANCIAITEM (1,N) <br>
* INSTANCIAITEM é gerado por um único ITEM (1,1) <br>

IMPLANTE - possui - COMPONENTE <br>
* IMPLANTE possui um ou vários COMPONENTES (1,N) <br>
* COMPONENTE é possuído por um ou vários IMPLANTES (1,N) <br>

## Histórico de versões

| Versão |  Data  | Descrição | Autor |
|:------:|:------:|:---------:|------:|
| 1.0 | 23/11/2024 | Criação do MER | [João Vitor Santos](https://github.com/Jauzimm) |
| 1.1 | 24/11/2024 | Adição dos Relacionamentos no MER | [João Vitor Santos](https://github.com/Jauzimm) |
| 1.2 | 25/11/2024 | Adição dos atributos das entidades | [Charles Serafim Morais](https://github.com/charles-serafim) |
| 1.3 | 25/11/2024 | Correções, adição da introdução | [Charles Serafim Morais](https://github.com/charles-serafim) |
