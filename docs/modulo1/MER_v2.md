# Modelo Entidade Relacionamento
## Segunda Versão

## Entidades

* **CYBERLUTADOR**
* **NPC**
    * **INIMIGO**
    * **INSTANCIAINIMIGO**
    * **MENTOR**
* **MOCHILA**
* **ITEM**
    * **INSTANCIAITEM**
    * **BIOCHIP**
* **IMPLANTE**
    * **BRACOROBOTICO**
    * **CAPACETENEURAL**
    * **VISAOCIBERNETICA**
* **MERCADOCLANDESTINO**
    * **MERCADOITEM**
* **MISSÃO**
  * **RECOMPENSA MISSÃO**
* **SALA**
* **REGIÃO**
* **PUZZLE**
*  **DIÁLOGO**
*  **FACÇÃO**
      *  **CODEKEEPERS**
      *  **NETRUNNERS**
* **RECOMPENSA**

## Atributos

* **CYBERLUTADOR**: idCyberLutador, nomeCyberLutador, velocidade, vida, inteligência, furtividade, percepção, resistência, força
* **NPC**: <u>idNPC</u>
    * **INIMIGO**: <u>idInimigo</u>, qtdDano, vida
    * **MENTOR**: <u>idMentor</u>,aumentaInteligencia, aumentaFurtividade, aumentaPercepcao
* **MOCHILA**: <u>idMochila</u>, capacidade
* **ITEM**: <u>idItem</u>, nomeItem, valor, descricao
  * **BIOCHIP** <u>idBiochip</u>, regeneraVida
* **IMPLANTE**: <u>idImplante</u>, nomeImplante, tipo
    * **BRACOROBOTICO** <u>idBracorobotico</u>, aumentaForca, aumentaVeloc
    * **CAPACETENEURAL** <u>CapaceteNeural</u>, aumentaInt, aumentaResis
    * **VISAOCIBERNETICA** <u>idVisaocibernetica</u>, aumentaFurti, aumentaPercep
* **MERCADOCLANDESTINO**: <u>idMercadoClandestino</u>, nomeMercado, descricao
* **MISSÃO**: <u>idMissao</u>, nomeMissao, objetivo, progresso
* **SALA**: <u>idSala</u>, nomeSala
* **REGIÃO**: <u>idRegiao</u>, nomeRegiao
* **PUZZLE**: <u>idPuzzle</u>, nomePuzzle, dificuldade, resposta, estado
* **DIÁLOGO**: <u>idDialogo</u>, nomeDialogo, descricao, resposta
* **FACÇÃO**: <u>idFaccao</u>, nomeFaccao, ideologia
    * **NETRUNNERS**: <u>idNetRunners</u>, aumentaInte, aumentaPercep
    * **CODEKEEPERS**: <u>idCodeKeepers</u>, aumentaVelo, aumentaResis
* **RECOMPENSA**: <u>idRecompensa</u>, dinheiro, item



## Relacionamentos
<br>
CYBERLUTADOR - participa - MISSÃO <br>
* CYBERLUTADOR participa de zero ou várias MISSÕES (0,N) <br>
* MISSÃO tem a participação de um unico CYBERLUTADOR (1,1) <br>

CYBERLUTADOR - esta - SALA <br>
* Varios CYBERLUTADOR estão em varias SALAS (N,M) <br>
* SALA pode estar com zero ou varios CYBERLUTADOR (0,N) <br>

CYBERLUTADOR - participa - FACCAO <br>
* CYBERLUTADOR participa de uma unica FACÇÃO (1,1) <br>
* FACÇÃO tem a participação de zero ou vários CYBERLUTADOR (0,N) <br>

NPC - possui - DIALOGO <br>
* NPC possui zero ou vários DIALOGOS (0,N) <br>
* DIALOGO é possuido por um unico NPC (1,1) <br>

MERCADOCLANDESTINO - vende - ITEM <br>
* MERCADOCLANDESTINO vende um ou varios ITENS (1,N) <br>
* ITEM é vendido por zero ou varios MERCADOCLANDESTINOS (0,N) <br>

CYBERLUTADOR - acessa - MERCADOCLANDESTINO <br>
* CYBERLUTADOR acessa zero ou varios MERCADOCLANDESTINOS (0,N) <br>
* MERCADOCLANDESTINO pode ser acessado por zero ou um unico CYBERLUTADOR (0,1) <br>

CYBERLUTADOR - resolve - PUZZLE <br>
* CYBERLUTADOR resolve zero ou um PUZZLE (0,1) <br>
* PUZZLE é resolvido por zero ou um CYBERLUTADOR (0,1) <br>

SALA - esta - REGIÃO <br>
* SALA esta em uma ou várias REGIÕES (1,N) <br>
* REGIÃO pode estar com zero ou várias SALAS (0,N) <br>

PUZZLE - esta - MISSÃO <br>
* PUZZLE esta em zero ou várias MISSÕES (0,N) <br>
* MISSÃO pode estar com zero ou varios PUZZLES (0,N) <br>

CYBERLUTADOR - enfrenta - INSTANCIAINIMIGO <br>
* CYBERLUTADOR enfrenta uma ou várias INSTANCIAINIMIGO (1,N) <br>
* INSTANCIAINIMIGO é enfrentado por um único CYBERLUTADOR (1,1) <br>

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

CYBERLUTADOR - resgata - RECOMPENSA  <br>
* CYBERLUTADOR resgata zero ou vários RECOMPENSAS (0,N) <br>
* RECOMPENSA é resgatada por zero ou vários CYBERLUTADORES (0,N) <br>

CYBERLUTADOR - realiza - MISSÃO  <br>
* CYBERLUTADOR realiza zero até 3 MISSÕES (0,3) <br>
* MISSÃO é ralizada por zero ou vários CYBERLUTADORES (0,N) <br>

## Histórico de versões

| Versão |  Data  | Descrição | Autor |
|:------:|:------:|:---------:|------:|
| 1.0 | 07/02/2025 | Criação do MER | [Gabrielly Assunção](https://github.com/GabriellyAssuncao) |

