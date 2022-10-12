import random
import pandas as pd
import dotenv 
import psycopg as pg
import yfinance as yf
from urllib.parse import quote

def main():
    indexes = [
        {
            "name": "IBOVEPSA",
            "yahoo_code": "^BVSP",
            "description": "Ibovespa"
        },
        {
            "name": "IBRX",
            "yahoo_code": "^IBX50",
            "description": "IBRX"
        }
    ]

    for index in indexes:
        ticker = yf.Ticker(index["yahoo_code"])
        
        ticker_components_url = "{}/{}/components".format(ticker._scrape_url, ticker.ticker)
        data = yf.utils.get_json(ticker_components_url)
        
        index["components"] = [component.split(".")[0] for component in data["components"]["components"]]

    dotenv.load_dotenv()
    with pg.connect("") as conn:
        with conn.cursor() as cur:
            for index in indexes:
                cur.execute("INSERT INTO indice (nome, descricao) VALUES (%s, %s)", (index["name"], index["description"]))
                conn.commit()

                cur.execute("SELECT id FROM indice WHERE nome = %s", (index["name"],))
                index_id = cur.fetchone()[0]
                
                random_weights = [random.random() for _ in index["components"]]
                random_weights = [weight / sum(random_weights) for weight in random_weights]

                for component, weight in zip(index["components"], random_weights):
                    
                    cur.execute("SELECT isin FROM ativo WHERE ticker = %s", (component,))
                    try:
                        isin_ativo = cur.fetchone()[0]
                        print(component)
                    except TypeError:
                        print("Ativo {} não encontrado".format(component))
                        continue

                    cur.execute("INSERT INTO composto_por (isin_ativo, id_indice, porcentagem) VALUES (%s, %s, %s)", (isin_ativo, index_id, weight*100))
                    
        conn.commit()

if __name__ == "__main__":
    main()