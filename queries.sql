-- A

-- Seleciona o valor que um usuário possui em um setor da bolsa
SELECT
    SETOR,
    SUM(quantidade * preco_medio) AS valor
FROM estoques
JOIN usuario ON estoques.ID_USUARIO = usuario.ID
JOIN acao ON estoques.ISIN_ATIVO = acao.ISIN_ATIVO
GROUP BY SETOR
WHERE usuario.email = 'algum@email.com';

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
SORT BY quantidade DESC;


-- B

-- Seleciona o id de transações feitas em ativos com baixa liquidez no mercado.
-- Pode indicar operações arriscadas e/ou com insider trading
SELECT
    TRANSACIONA.ID
FROM ATIVO
JOIN TRANSACIONA ON ATIVO.ISIN = TRANSACIONA.ISIN_ATIVO
WHERE ATIVO.ISIN IN (
    SELECT 
        ISIN_ATIVO,
    FROM HISTORICO_ATIVOS
    GROUP BY ISIN_ATIVO
    HAVING AVG(VOLUME) < 1000000
);


-- Seleciona o resultado do estoque dos clientes em um determinado dia, para cada ativo
SELECT
    id_usuario,
    isin_ativo,
    quantidade * preco_medio * variacao AS resultado
FROM estoques
JOIN (
    SELECT 
        ISIN_ATIVO,
        (D0.CLOSE / D1.CLOSE) - 1 AS VARIACAO
    FROM HISTORICO_ATIVOS AS D0
    JOIN HISTORICO_ATIVOS AS D1 ON D0.ISIN_ATIVO = D1.ISIN_ATIVO AND D0.DATA = D1.DATA - 1
    WHERE DATA = '2020-01-01'
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