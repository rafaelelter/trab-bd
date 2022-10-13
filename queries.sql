-- A

-- Seleciona o valor que um usuário possui em um setor da bolsa
SELECT
    SETOR,
    SUM(quantidade * preco_medio) AS valor
FROM estoques
JOIN usuario ON estoques.ID_USUARIO = usuario.ID
JOIN acao ON estoques.ISIN_ATIVO = acao.ISIN_ATIVO
WHERE usuario.email = 'soconnor@example.com'
GROUP BY SETOR;

-- Seleciona o nome de empresas e a quantidade de índices em que elas estão
-- filtrando apenas por empresas que estão em mais de um índice
-- e ordenando de forma decrescente pela quantidade de índices em que elas estão
SELECT
    EMPRESA.NOME,
    COUNT(*) AS quantidade
FROM COMPOSTO_POR
JOIN ATIVO ON COMPOSTO_POR.ISIN_ATIVO = ATIVO.ISIN
JOIN EMPRESA ON ATIVO.ID_EMPRESA = EMPRESA.CNPJ
GROUP BY NOME
HAVING COUNT(*) > 1
ORDER BY quantidade DESC;


-- B

-- Seleciona o id de transações feitas em ativos com baixa liquidez no mercado.
-- Pode indicar operações arriscadas e/ou com insider trading
SELECT
    TRANSACIONA.ID
FROM ATIVO
JOIN TRANSACIONA ON ATIVO.ISIN = TRANSACIONA.ISIN_ATIVO
WHERE ATIVO.ISIN IN (
    SELECT 
        ISIN_ATIVO
    FROM HISTORICO_ATIVOS
    GROUP BY ISIN_ATIVO
    HAVING AVG(VOLUME) < 450000
);


-- Seleciona o resultado do estoque dos clientes em um determinado dia, para cada ativo
SELECT
    id_usuario,
    estoques.isin_ativo,
    quantidade * preco_medio * variacao AS resultado
FROM estoques
JOIN (
    SELECT 
        D0.ISIN_ATIVO,
        (D0.CLOSE / D1.CLOSE) - 1 AS VARIACAO
    FROM HISTORICO_ATIVOS AS D0
    JOIN HISTORICO_ATIVOS AS D1 ON D0.ISIN_ATIVO = D1.ISIN_ATIVO AND D0.DATA = D1.DATA - 1
    WHERE D0.DATA = '2020-01-01'
) AS VARIACAO ON estoques.ISIN_ATIVO = VARIACAO.ISIN_ATIVO;


-- Ordena os usuários pelo valor gasto com os planos da aplicação
SELECT
    PLANO.NOME,
    USUARIO.NOME,
    SUM(COMPRA.VALOR) AS VALOR
FROM COMPRA
JOIN PLANO ON COMPRA.ID_PLANO = PLANO.ID
JOIN USUARIO ON COMPRA.ID_USUARIO = USUARIO.ID
GROUP BY PLANO.NOME, USUARIO.NOME
ORDER BY VALOR DESC;


-- Seleciona os usuarios que fizeram compras de plano em 2022
SELECT 
	USUARIO.NOME
FROM USUARIO
WHERE NOT EXISTS(SELECT * FROM COMPRA
JOIN PLANO ON COMPRA.ID_PLANO = PLANO.ID
JOIN USUARIO ON COMPRA.ID_USUARIO = USUARIO.ID
WHERE COMPRA.DATA < '2022-01-01')

-- Seleciona os 5 ativos com mais volume
SELECT DISTINCT
	ATIVO.TICKER
FROM ATIVO
JOIN HISTORICO_ATIVO ON HISTORICO_ATIVO.ISIN_ATIVO=ATIVO.ISIN
ORDER BY VOLUME DESC
LIMIT 5

-- Ordena os usuarios que mais transicionaram na bolsa na ultimas 24h
SELECT
	USUARIO.NOME
	COUNT(*) AS "Numero transacoes"
FROM USUARIO
JOIN TRANSACIONA ON TRANSACIONA.USUARIO_ID=USUARIO.USUARIO_ID
WHERE TRANSACIONA.DATA>current_date - INTEGER '1'
GROUP BY USUARIO.NOME
ORDER BY Numero transacoes

-- Seleciona os usuarios que possuem algum plano que vai expirar nos proximos 7 dias
SELECT DISTINCT
	USUARIO.NOME
FROM USUARIO
JOIN COMPRAS ON COMPRAS.USUARIO_ID=USUARIO.ID
WHERE COMPRAS.DATA_EXPIRACAO<current_date + INTEGER '7'


---Seleciona os planos e informa a quantidade de planos vendidos
SELECT 
	PLANO.NOME
	COUNT(*) AS "planos vendidos"
FROM COMPRAS 
JOIN PLANO ON PLANO.ID=COMPRAS.ID_PLANO
GROUP BY PLANO.NOME









