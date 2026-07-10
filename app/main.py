from fastapi import FastAPI

from app.routers import companies, personas, users

app = FastAPI(title="Backoffice de Gestão de Acessos (estado atual)")

app.include_router(companies.router)
app.include_router(users.router)
app.include_router(personas.router)


@app.get("/")
def root():
    return {"status": "ok", "aviso": "base intencionalmente bagunçada — ponto de partida do case"}
