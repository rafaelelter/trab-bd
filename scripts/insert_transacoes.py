from datetime import datetime, timedelta
import psycopg as pg
import dotenv
import random

TIPOS = ["C", "V"]

def main():
    dotenv.load_dotenv()

    with pg.connect("") as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT ISIN FROM ativo")
            isins = [tup[0] for tup in cur.fetchall()]

            cur.execute("SELECT id FROM usuario")
            ids = [tup[0] for tup in cur.fetchall()]

            for _ in range(1000):
                isin = random.choice(isins)
                id = random.choice(ids)
                quantidade = random.randint(1, 100)
                preco = random.randint(1, 100)
                data = datetime(2020, 1, 1) + timedelta(days=random.randint(0, 365*2))
                tipo = random.choice(TIPOS)

                cur.execute("INSERT INTO transaciona (isin_ativo, id_usuario, quantidade, preco, tipo, data) VALUES (%s, %s, %s, %s, %s, %s)", (isin, id, quantidade, preco, tipo, data))
        
        conn.commit()

if __name__ == "__main__":
    main()