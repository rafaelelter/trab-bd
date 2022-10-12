import psycopg as pg
import dotenv

sql_select_tables = """
    SELECT table_name
    FROM information_schema.tables 
    WHERE table_schema='public' AND table_type='BASE TABLE';
"""

sql_truncate_table = """
    TRUNCATE TABLE {table_name} CASCADE;
"""

def main():
    
    dotenv.load_dotenv()

    with pg.connect("") as conn:
        with conn.cursor() as cur:
            cur.execute(sql_select_tables)
            tables = [tup[0] for tup in cur.fetchall()]
            for table in tables:
                cur.execute(sql_truncate_table.format(table_name=table))
        
        conn.commit()


if __name__ == "__main__":
    main()