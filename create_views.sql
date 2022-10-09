CREATE VIEW estoques AS (
    SELECT
        id_usuario,
        isin_ativo,
        SUM(quantidade) AS quantidade,
        SUM(volume) / SUM(quantidade) AS preco_medio
    FROM (
        SELECT
            id_usuario,
            isin_ativo,
            CASE 
                WHEN tipo = 'C' THEN quantidade
                ELSE -quantidade
            END AS quantidade,
            preco * quantidade AS volume
        FROM transaciona
    ) AS quantidade_sinalizada
    GROUP BY id_usuario, isin_ativo
);