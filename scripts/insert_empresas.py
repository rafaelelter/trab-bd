import pandas as pd
import psycopg as pg
import dotenv

def fetch_data():
    url = "https://www.idinheiro.com.br/investimentos/cnpj-empresas-listadas-b3/"
    df = pd.read_html(url)[0]
    df = df[["Empresa", "Código(s)", "CNPJ"]]
    df.columns = ["EMPRESA", "TICKER", "CNPJ"]
    df["TICKER"] = df["TICKER"].str.split()
    
    df["CNPJ"] = df["CNPJ"].map(lambda x: int(x.replace(".", "").replace("/", "").replace("-", "")))

    df = df.explode("TICKER")
    return df

def main():
    df = fetch_data()
    df.to_csv("empresas.csv", index=False)

    df = df.drop_duplicates(subset=["CNPJ"])
    dotenv.load_dotenv()
    with pg.connect("") as conn:
        with conn.cursor() as cur:
            for _, row in df.iterrows():
                try:
                    cur.execute("INSERT INTO empresa (cnpj, nome) VALUES (%s, %s)", (row["CNPJ"], row["EMPRESA"]))
                except pg.errors.UniqueViolation:
                    pass
        conn.commit()


if __name__ == "__main__":
    main()