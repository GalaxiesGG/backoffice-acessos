import os

import psycopg2
import psycopg2.extras


def get_conn():
    """Conexão crua com o Postgres. Sem pool, sem ORM — reflete o estado atual."""
    return psycopg2.connect(os.environ["DATABASE_URL"])


def query(sql, params=None):
    conn = get_conn()
    try:
        cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
        cur.execute(sql, params or ())
        rows = cur.fetchall()
        conn.commit()
        return [dict(r) for r in rows]
    finally:
        conn.close()


def execute(sql, params=None):
    conn = get_conn()
    try:
        cur = conn.cursor()
        cur.execute(sql, params or ())
        conn.commit()
    finally:
        conn.close()
