# Projeto Java: Script para Inserção de Dados no PostgreSQL

## 1. Introdução
Este projeto tem como objetivo realizar a inserção massiva de dados em um banco de dados PostgreSQL. O script em Java é responsável por gerar 2 milhões de registros e inseri-los na base de dados de forma eficiente.

## 2. Tecnologias Utilizadas
- **Java**: Linguagem principal para o desenvolvimento do script.
- **PostgreSQL**: Sistema de gerenciamento de banco de dados.
- **JDBC (Java Database Connectivity)**: API usada para conectar e interagir com o banco de dados PostgreSQL.

## 3. Estrutura do Projeto
O projeto segue uma estrutura simples com os seguintes componentes principais:

### 3.1. `Main.java`
A classe principal responsável por:
- Conectar ao banco de dados.
- Gerar registros para inserção.
- Executar as inserções.

### 3.2. `DatabaseConnection.java`
Classe utilitária para gerenciar a conexão com o banco de dados PostgreSQL. Ela contém:
- Configurações de conexão (URL, usuário, senha).
- Métodos para abrir e fechar conexões.

### 3.3. `DataInserter.java`
Classe que contém a lógica de inserção dos dados. Principais funções:
- Gerar 2 milhões de registros fictícios.
- Inserir os dados utilizando transações para maior eficiência.

## 4. Funcionalidades Principais

### 4.1. Conexão com o Banco de Dados
O script se conecta ao PostgreSQL usando JDBC. A conexão é configurada no arquivo `DatabaseConnection.java`, onde estão as informações de acesso ao banco, como:
  ```java
  String url = "jdbc:postgresql://localhost:5432/meubanco";
  String user = "usuario";
  String password = "senha";
  ```
### 4.2. Geração de Registros
A classe `DataInserter.java` é responsável por gerar os dados a serem inseridos no banco. Cada registro contém informações como:
- **ID** (auto-gerado)
- **Nome**
- **Endereço**
- **Data de criação**

### 4.3. Inserção dos Dados
Os dados gerados são inseridos em lotes para otimizar o desempenho da inserção. O método `batchInsert()` utiliza o conceito de transações para agrupar várias inserções em um único commit.

```java
connection.setAutoCommit(false);
for (int i = 0; i < 2000000; i++) {
    // Lógica de inserção
}
connection.commit();
```
### 4.4. Mensuração de Tempo de Execução
O tempo de execução do processo de inserção é monitorado para fins de otimização e análise de performance. A captura do tempo de início e término é feita utilizando `System.currentTimeMillis()`.

## 5. Como Executar o Projeto

### 5.1. Pré-requisitos
- Java 11 ou superior instalado.
- PostgreSQL instalado e configurado.
- Dependências JDBC no projeto (adicionadas via Maven ou manualmente).

### 5.2. Passos para Executar
1. Clone o repositório do projeto:

    ```bash
    git clone https://github.com/seuprojeto.git
    ```

2. Compile e execute o projeto a partir do `Main.java`:

    ```bash
    javac Main.java
    java Main
    ```


