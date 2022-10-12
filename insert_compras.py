import psycopg as pg
import dotenv
import random
from datetime import datetime, timedelta

def main():
    dotenv.load_dotenv()
    
    with pg.connect("") as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT ID FROM usuario")
            ids_usuarios = [tup[0] for tup in cur.fetchall()]

            cur.execute("SELECT ID FROM plano")
            ids_planos = [tup[0] for tup in cur.fetchall()]

            for _ in range(100):
                id_usuario = random.choice(ids_usuarios)
                id_plano = random.choice(ids_planos)
                data = datetime(2020, 1, 1) + timedelta(days=random.randint(0, 365*2))
                data_expiracao = data + timedelta(days=365)
                valor = random.randint(0, 100)
                
                cur.execute("INSERT INTO compra (id_usuario, id_plano, data, data_expiracao, valor) VALUES (%s, %s, %s, %s, %s)", (id_usuario, id_plano, data, data_expiracao, valor))

        conn.commit()

if __name__ == "__main__":
    main()