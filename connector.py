import psycopg2
import sqlalchemy as db

def read_credentials():
    with open('credentials.txt') as f:
        connection_string = f.read()
    return connection_string
        
def connect_to(db_name='postgres'):
    if db_name == 'postgres':
        with open('credentials.txt') as f:
            connection_string = f.read()
        engine = db.create_engine(connection_string)
        conn = engine.connect()

    return conn

