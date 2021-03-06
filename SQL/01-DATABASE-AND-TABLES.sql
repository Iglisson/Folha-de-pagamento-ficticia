-- CRIA??O DO BANCO DE DADOS
CREATE DATABASE DB_INSTITUTO

-- SELE??O DO BANCO DE DADOS
USE DB_INSTITUTO

-- CRIA??O DA TABELA FUNCIONARIOS
CREATE TABLE FUNCIONARIOS 
(
MATRICULA VARCHAR(4) NOT NULL,
CPF VARCHAR(15) NOT NULL,
NOME VARCHAR(40) NOT NULL,
LOCAL_NASC VARCHAR(20) NOT NULL,
ESCOLARIDADE CHAR(1) NOT NULL,
CARGO INT NOT NULL,
ADMISSAO DATE NOT NULL,
NASCIMENTO DATE NOT NULL,
DEPENDENTES INT NOT NULL DEFAULT 0,
VALE_TRANSP CHAR(1) NOT NULL,
PLANO_SAUDE CHAR(1) NOT NULL,
PRIMARY KEY (MATRICULA),
CONSTRAINT FK_FUNCIOCARGO FOREIGN KEY (CARGO) REFERENCES CARGOS (CARGO)
)

-- CRIA??O DA TABELA CARGOS
CREATE TABLE CARGOS 
(
CARGO INT NOT NULL,
NOMECARGO VARCHAR(40) NOT NULL,
SALARIO NUMERIC(10,2) NOT NULL,
PRIMARY KEY (CARGO) NOT NULL
)