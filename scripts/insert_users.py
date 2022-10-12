import faker
import psycopg as pg
import dotenv


def main():
    dotenv.load_dotenv()
    
    with pg.connect("") as conn:
        with conn.cursor() as cur:
            fake = faker.Faker()
            for i in range(100):
                nome = fake.name()
                email = fake.email()
                senha = fake.password()
                cur.execute("INSERT INTO usuario (nome, email, senha) VALUES (%s, %s, %s)", (nome, email, senha))
        conn.commit()

if __name__ == "__main__":
    main()