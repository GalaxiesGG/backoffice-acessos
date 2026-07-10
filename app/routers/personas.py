from fastapi import APIRouter
from pydantic import BaseModel

from app.db import execute, query

router = APIRouter(prefix="/personas", tags=["personas"])


class PersonaEdit(BaseModel):
    title: str | None = None
    description: str | None = None
    avatar_url: str | None = None
    tags: str | None = None


@router.get("")
def search_personas(q: str | None = None, language: str = "pt"):
    # bug: o parâmetro q é aceito mas NUNCA entra no WHERE -> a busca não filtra nada
    return query("SELECT * FROM personas WHERE language = %s ORDER BY external_id", (language,))


@router.put("/{external_id}")
def edit_persona(external_id: str, language: str, payload: PersonaEdit):
    # edição idioma por idioma: só afeta a linha daquele idioma
    execute(
        """UPDATE personas
           SET title = COALESCE(%s, title),
               description = COALESCE(%s, description),
               avatar_url = COALESCE(%s, avatar_url),
               tags = COALESCE(%s, tags)
           WHERE external_id = %s AND language = %s""",
        (payload.title, payload.description, payload.avatar_url, payload.tags, external_id, language),
    )
    return {"ok": True}
