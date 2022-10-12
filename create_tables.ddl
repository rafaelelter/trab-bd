-- *********************************************
-- * SQL PostgreSQL generation                 
-- *--------------------------------------------
-- * DB-MAIN version: 11.0.2              
-- * Generator date: Sep 14 2021              
-- * Generation date: Sun Aug 14 18:32:04 2022 
-- * LUN file: G:\My Drive\UFRGS\ECP\BD\PORTFOLIO_MANAGEMENT.lun 
-- * Schema: PORTFOLIO_MANAGEMENT/1 
-- ********************************************* 


-- Database Section
-- ________________ 

-- create database PORTFOLIO_MANAGEMENT if not exists;

-- \connect PORTFOLIO_MANAGEMENT

begin;

-- Tables Section
-- _____________ 


create table ACAO (
     ISIN_ATIVO char(12) not null,
     TIPO char(2) not null,
     SETOR varchar(30) not null,
     constraint FKATI_ACAO_ID primary key (ISIN_ATIVO));

create table ATIVO (
     ISIN char(12) not null,
     ID_EMPRESA numeric not null,
     TICKER varchar(12) not null,
     constraint IDSECURITY_ID primary key (ISIN));

create table COMPOSTO_POR (
     ISIN_ATIVO char(12) not null,
     ISIN_ETF char(12) not null,
     PORCENTAGEM numeric(3) not null,
     constraint IDCOMPOSTO_POR primary key (ISIN_ATIVO, ISIN_ETF));

create table COMPRA (
     ID serial not null,
     DATA date not null,
     DATA_EXPIRACAO date not null,
     VALOR numeric(10,2) not null,
     ID_USUARIO integer not null,
     ID_PLANO integer not null,
     constraint IDPURCHASE primary key (ID));

create table EMPRESA (
     CNPJ numeric(14) not null,
     NOME varchar(80) not null,
     constraint IDEMPRESA_ID primary key (CNPJ));

create table ETF (
     ISIN_ATIVO char(12) not null,
     ID_INDICE integer,
     constraint FKFUN_ETF_ID primary key (ISIN_ATIVO));

create table EVENTO (
     ID serial not null,
     ISIN char(12) not null,
     TIPO varchar(30) not null,
     DATA date not null,
     VALOR numeric(20,6) not null,
     constraint IDEVENTS primary key (ID));

create table FUNDO (
     ISIN_ATIVO char(12) not null,
     ID_ADM numeric(14) not null,
     constraint FKATI_FUNDO_ID primary key (ISIN_ATIVO));

create table FUNDO_IMOBILIARIO (
     ISIN_ATIVO char(12) not null,
     TIPO varchar(30) not null,
     constraint FKFUN_FII_ID primary key (ISIN_ATIVO));

create table HISTORICO_ATIVOS (
     ISIN_ATIVO char(12) not null,
     DATA date not null,
     OPEN numeric(10,2) not null,
     HIGH numeric(10,2) not null,
     LOW numeric(10,2) not null,
     CLOSE numeric(10,2) not null,
     ADJ_CLOSE float(10) not null,
     VOLUME numeric(20,2) not null,
     constraint IDHISTORICO_ATIVOS primary key (ISIN_ATIVO, DATA));

create table HISTORICO_INDICE (
     ID_INDICE integer not null,
     DATA date not null,
     OPEN numeric(10,2) not null,
     HIGH numeric(10,2) not null,
     LOW numeric(10,2) not null,
     CLOSE numeric(10,2) not null,
     constraint IDHISTORICO_INDICE primary key (ID_INDICE, DATA));

create table INDICE (
     ID serial not null,
     NOME varchar(80) not null,
     DESCRICAO varchar(240) not null,
     constraint IDINDEX_ID primary key (ID));

create table PLANO (
     ID serial not null,
     NOME varchar(80) not null,
     PRECO numeric(10,2) not null,
     DURACAO numeric(10) not null,
     constraint IDPLANS primary key (ID));

create table TRANSACIONA (
     ID serial not null,
     DATA date not null,
     TIPO char(1) not null,
     QUANTIDADE numeric(10,2) not null,
     PRECO numeric(10,2) not null,
     ID_USUARIO integer not null,
     ISIN_ATIVO char(12) not null,
     constraint IDTRANSACTION primary key (ID));

create table USUARIO (
     ID serial not null,
     NOME varchar(80) not null,
     EMAIL varchar(80) not null,
     SENHA varchar(50) not null,
     constraint IDUSER primary key (ID));


-- Constraints Section
-- ___________________ 

alter table ACAO add constraint FKATI_ACAO_FK
     foreign key (ISIN_ATIVO)
     references ATIVO;

--Not implemented
--alter table ATIVO add constraint IDSECURITY_CHK
--    check(not exists(select * from COMPOSTO_POR
--                where COMPOSTO_POR.ISIN_ATIVO = ISIN)); 

--Not implemented
--alter table ATIVO add constraint IDSECURITY_CHK
--     check(exists(select * from EVENTO
--                  where EVENTO.ISIN = ISIN)); 

--Not implemented
--alter table ATIVO add constraint IDSECURITY_CHK
--     check(exists(select * from HISTORICO_ATIVOS
--                  where HISTORICO_ATIVOS.ISIN_ATIVO = ISIN)); 

alter table ATIVO add constraint FKPERTENCE
     foreign key (ID_EMPRESA)
     references EMPRESA;

alter table COMPOSTO_POR add constraint FKCOM_ATI
     foreign key (ISIN_ATIVO)
     references ATIVO;

alter table COMPOSTO_POR add constraint FKR
     foreign key (ISIN_ETF)
     references ETF;

alter table COMPRA add constraint FKCOM_PLA
     foreign key (ID_PLANO)
     references PLANO;

alter table COMPRA add constraint FKCOM_USU
     foreign key (ID_USUARIO)
     references USUARIO;

--Not implemented
--alter table EMPRESA add constraint IDEMPRESA_CHK
--     check(exists(select * from FUNDO
--                  where FUNDO.ID_ADM = ID)); 

--Not implemented
--alter table EMPRESA add constraint IDEMPRESA_CHK
--     check(exists(select * from ATIVO
--                  where ATIVO.ID_EMPRESA = ID)); 

alter table ETF add constraint FKEMULA
     foreign key (ID_INDICE)
     references INDICE;

--Not implemented
-- alter table ETF add constraint FKFUN_ETF_CHK
--     check(exists(select * from COMPOSTO_POR
--                  where COMPOSTO_POR.ISIN_ETF = ISIN_ATIVO)); 

alter table ETF add constraint FKFUN_ETF_FK
     foreign key (ISIN_ATIVO)
     references FUNDO;

alter table EVENTO add constraint FKOCORREM
     foreign key (ISIN)
     references ATIVO;

alter table FUNDO add constraint FKADMINISTRA
     foreign key (ID_ADM)
     references EMPRESA;

alter table FUNDO add constraint FKATI_FUNDO_FK
     foreign key (ISIN_ATIVO)
     references ATIVO;

alter table FUNDO_IMOBILIARIO add constraint FKFUN_FII_FK
     foreign key (ISIN_ATIVO)
     references FUNDO;

alter table HISTORICO_ATIVOS add constraint FKPASSADO_DO_ATIVO
     foreign key (ISIN_ATIVO)
     references ATIVO;

alter table HISTORICO_INDICE add constraint FKR
     foreign key (ID_INDICE)
     references INDICE;

--Not implemented
--alter table INDICE add constraint IDINDEX_CHK
--     check(exists(select * from HISTORICO_INDICE
--                  where HISTORICO_INDICE.ID_INDICE = ID)); 

alter table TRANSACIONA add constraint FKTRA_USU
     foreign key (ID_USUARIO)
     references USUARIO;

alter table TRANSACIONA add constraint FKTRA_ATI
     foreign key (ISIN_ATIVO)
     references ATIVO;

alter table TRANSACIONA add constraint IS_IN_TRA_TIPO
     CHECK (TIPO IN ('C', 'V'));

-- Index Section
-- _____________ 

commit;