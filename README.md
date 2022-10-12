# Gerenciador de Portfolio

## Trabalho de Banco de Dados
Alunos: Arthur Krieger e Rafael Elter

## Requisitos
 - Python 3.9
 - PostgreSQL 14

## Setup

1. Criar as tabelas, triggers e views no postgres
Dentro do psql
```
\i create_tables.ddl
\i create_trigger.sql
\i create_views.sql
```

2. Criar um arquivo .env com base no arquivo .env.dummy
Atualizar as variáveis para a sua configuração do PostgreSQL.

3. Instalar os pacotes para importação de dados:
```
pip install -r requirements.txt
```

4. Rodar os scripts para popular as tabelas
```
python main.py
```

## Queries
As queries se encontram no arquivo `queries.sql`.