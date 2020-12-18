import os
import psycopg2
from psycopg2.extras import execute_batch
import json
import pandas as pd
import download_queries
import import_data


password = os.environ.get('DEFAULT_PG_PASS')
#todo: figure out environemnt variable issues
conn_op = psycopg2.connect(f'postgresql://postgres:pw@0.0.0.0:5432/orders')
conn_star = psycopg2.connect(f'postgresql://postgres:pw@0.0.0.0:5432/orders_2')

tables = []


def sql_to_df(cursor, query, name):
    cursor.execute(query)
    data = cursor.fetchall()
    df = pd.DataFrame(data)
    df.columns = [x.name for x in cursor.description]
    df.name = name
    return df


with conn_op.cursor() as cur:
    cur.execute(download_queries.sales_query)
    tables.append(sql_to_df(cur, download_queries.date_query, 'date_dimension'))
    tables.append(sql_to_df(cur, 'select * from sales_fact', 'sales_fact'))
    tables.append(sql_to_df(cur, download_queries.product_query, 'product_dimension'))
    tables.append(sql_to_df(cur, download_queries.customer_query, 'customer_dimension'))

with conn_star.cursor() as cur:
    sql_file = open('star_schema_create.sql', 'r')
    cur.execute(sql_file.read())
conn_star.commit()

with conn_star.cursor() as cur:
    import_data.upload_table_data(conn_star,  tables)
    cur.execute('select * from sales_fact limit 10')
    test = cur.fetchall()

conn_star.commit()
conn_op.close()
conn_star.close()
