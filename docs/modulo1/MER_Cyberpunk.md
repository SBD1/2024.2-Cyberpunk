# Introdução
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

EXOHUMANO - participa - MISSÃO
* EXOHUMANO participa de zero ou várias MISSÕES (0,1)
* MISSÃO tem a participação de um unico EXOHUMANO (1,1)

EXOHUMANO - possui - DIALOGO
* EXOHUMANO possui zero ou vários DIALOGOS (0,1)
* DIALOGO é possuido por um unico EXOHUMANO (1,1)

EXOHUMANO - esta - SALA
* Varios EXOHUMANOS estão em varias SALAS (N, M)
* SALA pode estar com zero ou varios EXOHUMANOS (0,N)

EXOHUMANO - participa - FACCAO
* EXOHUMANO participa de uma unica FACÇÃO (1,1)
* FACÇÃO tem a participação de zero ou vários EXOHUMANOS (0,N)

NPC - possui - MERCADOCLANDESTINO
* NPC possui zero ou um MERCADOCLANDESTINO (0,1)
* MERCADOCLANDESTINO é possuido por um unico NPC (1,1)

MERCADOCLANDESTINO - possui - CARRO
* MERCADOCLANDESTINO possui zero ou vários CARROS (0,N)
* CARRO é possuido por um único MERCADOCLANDESTINO (1,1)

MERCADOCLANDESTINO - vende - ITEM
* MERCADOCLANDESTINO vende um ou varios ITENS (1,N)
* ITEM é vendido por zero ou varios MERCADOCLANDESTINOS (0,N)

PLAYER - acessa - MERCADOCLANDESTINO
* PLAYER acessa zero ou varios MERCADOCLANDESTINOS (0,N)
* MERCADOCLANDESTINO pode ser acessado por zero ou um unico PLAYER (0,1)

PLAYER - utiliza - CARRO
* PLAYER utiliza zero ou um CARRO (0,1)
* CARRO é utilizado por zero ou um PLAYER (0,1)

PLAYER - resolve - PUZZLE
* PLAYER resolve zero ou um PUZZLE (0,1)
* PUZZLE é resolvido por zero ou um PLAYER (0,1)

CARRO - esta - REGIÃO 
* CARRO esta em uma única REGIÃO (1,1)
* REGIÃO pode estar com zero ou vários CARROS (0,N)

REGIÃO - esta - MAPA
* REGIÃO esta em um único MAPA (1,1)
* MAPA pode estar com um ou várias REGIÕES (1,N)

SALA - esta - REGIÃO
* SALA esta em uma ou várias REGIÕES (1,N)
* REGIÃO pode estar com zero ou várias SALAS (0,N)

SALA - conecta - SALA
* SALA conecta em uma ou seis SALAS (1,6)
* SALA é conectada por uma ou seis SALA (1,6)

PUZZLE - esta - MISSÃO
* PUZZLE esta em zero ou várias MISSÕES (0,N)
* MISSÃO pode estar com zero ou varios PUZZLES (0,N)

PLAYER - enfrente - INSTANCIAINIMIGO
* PLAYER enfrenta uma ou várias INSTANCIAINIMIGO (1,N)
* INSTANCIAINIMIGO é enfrentado por um único PLAYER (1,1)

Inimigo - gera - INSTANCIAINIMIGO
* Inimigo gera uma ou várias InstanciasInimigo (1,N)
* INSTANCIAINIMIGO é gerado por um único Inimio (1,1)

CYBERLUTADOR - possui - MOCHILA
* CYBERLUTADOR possui uma ou várias MOCHILAS (1,N)
* MOCHILA é possuída por um único CYBERLUTADOR (1,1)

CYBERLUTADOR - utiliza - IMPLANTE 
* CYBERLUTADOR utiliza zero ou vários IMPLANTES (0,N)
* IMPLANTE é utilizado por zero ou vários CYBERLUTADOR (0,N)

MOCHILA - possui - INSTANCIAITEM
* MOCHILA possui zero ou várias INSTANCIAITEM (0,N)
* INSTANCIAITEM é possuída por zero ou várias MOCHILAS (0,N)

ITEM - gera - INSTANCIAITEM
* ITEM gera um ou várias INSTANCIAITEM (1,N)
* INSTANCIAITEM é gerado por um único ITEM (1,1)

IMPLANTE - possui - COMPONENTE
* IMPLANTE possui um ou vários COMPONENTES (1,N)
* COMPONENTE é possuído por um ou vários IMPLANTES (1,N)

## Histórico de versões

| Versão |  Data  | Descrição | Autor |
|:------:|:------:|:---------:|------:|
| 1.0 | 23/11/2024 | Criação do MER | [João Vitor Santos](https://github.com/Jauzimm) |
| 1.1 | 24/11/2024 | Adição dos Relacionamentos no MER | [João Vitor Santos](https://github.com/Jauzimm) |
| 1.2 | 25/11/2024 | Adição dos atributos das entidades | [Charles Serafim Morais](https://github.com/charles-serafim) |
