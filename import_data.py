
from psycopg2.extras import execute_batch


def get_tuples(d):
    datadict = d.to_dict('records')
    return [tuple(d.values()) for d in datadict]


def insert_data(table, cur):
    fields = [col for col in table.columns]
    str_sub = ', '.join(['%s'] * len(fields))
    query = f"INSERT INTO {table.name}({', '.join(fields)}) VALUES ({str_sub})"
    execute_batch(cur, query, get_tuples(table))


def upload_table_data(conn,tables):
    with conn.cursor() as cur:
        tables_to_insert = tables
        for table in tables_to_insert:
            insert_data(table, cur)