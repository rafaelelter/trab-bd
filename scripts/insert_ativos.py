import pandas as pd
import psycopg as pg
import random
import dotenv
import string

def create_isins():
    df = pd.read_csv("empresas.csv")
    df["YF_TICKER"] = df["TICKER"] + ".SA"

    # 12 random digit code"
    df["ISIN"] = df.TICKER.map(lambda x: ''.join(random.choice(string.digits + string.ascii_uppercase) for _ in range(12)))

    return df[["ISIN", "CNPJ", "TICKER"]]

def main():
    df = create_isins()
    df.to_csv("isin_empresas.csv", index=False)

    dotenv.load_dotenv()
    with pg.connect("") as conn:
        with conn.cursor() as cur:
            for row in df.itertuples():
                cur.execute("INSERT INTO ativo (isin, id_empresa, ticker) VALUES (%s, %s, %s)", (row.ISIN, row.CNPJ, row.TICKER))
        
        conn.commit()

if __name__ == "__main__":
    main()