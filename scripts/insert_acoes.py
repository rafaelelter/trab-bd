import psycopg as pg
import dotenv
import random

SETORES = [
    "AERONAUTICA",
    "AGROPECUARIA",
    "ALIMENTOS",
    "ALUMINIO",
    "AUTOMOTIVA",
    "BANCOS",
    "BEBIDAS",
    "BENS DE CONSUMO",
]

TIPOS = [
    "ON",
    "PN",
    "UN",
]

def main():
    dotenv.load_dotenv()

    with pg.connect("") as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT ISIN FROM ativo")
            isins = [tup[0] for tup in cur.fetchall()]

            for isin in isins:
                tipo = random.choice(TIPOS)
                setor = random.choice(SETORES)
                cur.execute("INSERT INTO acao (isin_ativo, tipo, setor) VALUES (%s, %s, %s)", (isin, tipo, setor))


if __name__ == "__main__":
    main()