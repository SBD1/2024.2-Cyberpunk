## Histórico de versões

| Versão |  Data  | Descrição | Autor |
|:------:|:------:|:---------:|------:|
| 1.0 | 23/11/2024 | Criação do MER | [João Vitor Santos](https://github.com/Jauzimm) |

# Modelo Entidade Relacionamento

## Entidades

* **ExoHumano**
    * **NPC**
    * **CyberLutador**
        * **Inimigo**
        * **Player**
* **Mochila**
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
* Sala pode estar com zero ou varios ExoHumanos (0,n)

NPC - possui - MercadoClandestino
* NPC possui zero ou um MercadoClandestino (0,1)
* MercadoClandestino é possuido por um unico NPC (1,1)

CyberLutador - possui - Mochila
* CyberLutador possui uma ou varias Mochilas (1, N)
* Mochila é possuida por um único cyberLutador (1, 1)