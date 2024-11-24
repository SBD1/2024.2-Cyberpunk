# Introdução
# Modelo Entidade Relacionamento

## Entidades

* **ExoHumano**
    * **NPC**
    * **CyberLutador**
        * **Inimigo**
        * **InstanciaInimigo**
        * **Player**
* **Mochila**
* **InstanciaItem**
* **Item**
    * **Componente**
    * **BioChip**
        * **ChipCura**
        * **ChipAdrenalina**
    * **ItemChave**
* **Implante**
    * **BracoRobotico**
    * **CapaceteNeural**
    * **VisaoCibernetica**
* **MercadoClandestino**
* **Missão**
* **Sala**
* **Regiao**
* **Mapa**
* **Puzzle**
    * **Decodificar**
    * **Matematico**
* **Carro**

## Atributos

* **ExoHumano**: 
    * **NPC**: 
    * **CyberLutador**:
        * **Inimigo**:
        * **Player**:
* **Mochila**:
* **Item**:
    * **Componente**:
    * **BioChip**:
        * **ChipCura**:
        * **ChipAdrenalina**:
    * **ItemChave**:
* **Implante**:
    * **BracoRobotico**:
    * **CapaceteNeural**:
    * **VisaoCibernetica**:
* **MercadoClandestino**:
* **Missão**:
* **Sala**:
* **Regiao**:
* **Mapa**:
* **Puzzle**:
    * **Decodificar**:
    * **Matematico**:
* **Carro**:

## Relacionamentos

ExoHumano - participa - Missao
* ExoHumano participa de zero ou várias Missões (0,1)
* Missão tem a participação de um unico ExoHumano (1,1)

ExoHumano - possui - Dialogo
* ExoHumano possui zero ou vários Dialogos (0,1)
* Dialogo é possuido por um unico ExoHumano (1,1)

ExoHumano - esta - Sala
* Varios ExoHumanos estão em varias Salas (N, M)
* Sala pode estar com zero ou varios ExoHumanos (0,N)

ExoHumano - participa - Faccao
* ExoHumano participa de uma unica Facçao (1,1)
* Facção tem a participação de zero ou vários ExoHumanos (0,N)

NPC - possui - MercadoClandestino
* NPC possui zero ou um MercadoClandestino (0,1)
* MercadoClandestino é possuido por um unico NPC (1,1)

MercadoClandestino - possui - Carro
* MercadoClandestino possui zero ou vários Carros (0,N)
* Carro é possuido por um único MercadoClandestino (1,1)

MercadoClandestino - vende - Item
* MercadoClandestino vende um ou varios Itens (1,N)
* Item é vendido por zero ou varios MercadoClandestinos (0,N)

Player - acessa - MercadoClandestino
* Player acessa zero ou varios MercadoClandestinos (0,N)
* MercadoClandestino pode ser acessado por zero ou um unico Player (0,1)

Player - utiliza - Carro
* Player utiliza zero ou um Carro (0,1)
* Carro é utilizado por zero ou um Player (0,1)

Player - resolve - Puzzle
* Player resolve zero ou um Puzzle (0,1)
* Puzzle é resolvido por zero ou um Player (0,1)

Carro - esta - Regiao 
* Carro esta em uma única Região (1,1)
* Região pode estar com zero ou vários Carros (0,N)

Região - esta - Mapa
* Região esta em um único Mapa (1,1)
* Mapa pode estar com um ou várias Regiões (1,N)

Sala - esta - Regiao
* Sala esta em uma ou várias Regiões (1,N)
* Região pode estar com zero ou várias Salas (0,N)

Sala - conecta - Sala
* Sala conecta em uma ou seis Salas (1,6)
* Sala é conectada por uma ou seis Sala (1,6)

Puzzle - esta - Missão
* Puzzle esta em zero ou várias missões (0,N)
* Missão pode estar com zero ou varios Puzzles (0,N)

Player - enfrente - InstanciaInimigo
* Player enfrenta uma ou várias InstanciaInimigo (1,N)
* InstanciaInimigo é enfrentado por um único player (1,1)

Inimigo - gera - InstanciaInimigo
* Inimigo gera uma ou várias InstanciasInimigo (1,N)
* InstanciaInimigo é gerado por um único Inimio (1,1)

CyberLutador - possui - Mochila
* CyberLutador possui uma ou várias Mochilas (1,N)
* Mochila é possuída por um único CyberLutador (1,1)

CyberLutador - utiliza - Implante 
* CyberLutador utiliza zero ou vários Implantes (0,N)
* Implante é utilizado por zero ou vários CyberLutador (0,N)

Mochila - possui - InstanciaItem
* Mochila possui zero ou várias InstanciaItem (0,N)
* InstanciaItem é possuída por zero ou várias Mochilas (0,N)

Item - gera - InstanciaItem
* Item gera um ou várias InstanciaItem (1,N)
* InstanciaItem é gerado por um único Item (1,1)

Implante - possui - Componente
* Implante possui um ou vários Componentes (1,N)
* Componente é possuído por um ou vários Implantes (1,N)

## Histórico de versões

| Versão |  Data  | Descrição | Autor |
|:------:|:------:|:---------:|------:|
| 1.0 | 23/11/2024 | Criação do MER | [João Vitor Santos](https://github.com/Jauzimm) |
| 1.1 | 24/11/2024 | Adição dos Relacionamentos no MER | [João Vitor Santos](https://github.com/Jauzimm) |
