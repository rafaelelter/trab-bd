import random
import psycopg as pg
import dotenv
from datetime import datetime, timedelta

def main():

    dotenv.load_dotenv()
    with pg.connect("") as conn:
        with conn.cursor() as curs:
            curs.execute("SELECT isin FROM ativo")
            isins = [tup[0] for tup in curs.fetchall()]

            for isin in isins:
                data = datetime(2020, 1, 1)
                open_ = random.randint(1, 100)

                for _ in range(100):
                    high = open_ * 1.01
                    low = open_ * 0.99
                    close = open_ * (random.random() - 0.5)/10 + open_
                    adj_close = close
                    volume = random.randint(1, 1_000_000)
                    curs.execute("INSERT INTO historico_ativos (isin_ativo, data, open, high, low, close, adj_close, volume) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)", (isin, data, open_, high, low, close, adj_close, volume))
                    open_ = close * (random.random() - 0.5)/10 + close
                    data += timedelta(days=1)
        conn.commit()

if __name__ == "__main__":
    main()