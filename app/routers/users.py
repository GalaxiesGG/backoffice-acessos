from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from app.db import execute, query

router = APIRouter(prefix="/users", tags=["users"])


class NewUser(BaseModel):
    email: str
    name: str
    company_id: int | None = None


class ClusterEdit(BaseModel):
    cluster_ids: list[str]   # clusters da EMPRESA sendo editada


@router.post("")
def create_user(payload: NewUser):
    # 400 em cascata: se o e-mail já está na whitelist, recusa a criação
    wl = query("SELECT * FROM whitelist WHERE email = %s", (payload.email,))
    if wl:
        raise HTTPException(status_code=400, detail="E-mail já está na whitelist")

    execute(
        "INSERT INTO users (email, name, company_id, status, role) VALUES (%s, %s, %s, 'active', 'user')",
        (payload.email, payload.name, payload.company_id),
    )
    return {"ok": True}


@router.post("/signup")
def signup(payload: NewUser):
    # auto-cadastro entra em limbo: pending_approval, sem fluxo automático pra sair
    execute(
        "INSERT INTO users (email, name, company_id, status, role) VALUES (%s, %s, NULL, 'pending_approval', 'user')",
        (payload.email, payload.name),
    )
    return {"status": "pending_approval"}


@router.put("/{user_id}/clusters")
def edit_clusters(user_id: int, payload: ClusterEdit):
    # anti-padrão: apaga TUDO e reinsere. Perde histórico.
    # bug: para admin interno multi-conta, sobrescreve com os clusters de UMA empresa só,
    #      derrubando o acesso dele às outras contas.
    execute("DELETE FROM user_clusters WHERE user_id = %s", (user_id,))
    new_value = "{" + ",".join(payload.cluster_ids) + "}"
    execute(
        "INSERT INTO user_clusters (user_id, cluster_id) VALUES (%s, %s)",
        (user_id, new_value),
    )
    return {"ok": True}
