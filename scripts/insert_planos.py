import psycopg as pg
import dotenv

sql = """
    INSERT INTO PLANO (NOME, PRECO, DURACAO) VALUES
        ('Completo Ano', 25.00, 365), 
        ('Completo Mês', 5.00, 30), 
        ('Ações Ano', 12.00, 365);
"""

def main():
    dotenv.load_dotenv()
    
    with pg.connect("") as conn:
        with conn.cursor() as cur:
            cur.execute(sql)
        conn.commit()

if __name__ == "__main__":
    main()