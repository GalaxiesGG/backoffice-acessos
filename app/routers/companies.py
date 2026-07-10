from fastapi import APIRouter

from app.db import query

router = APIRouter(prefix="/companies", tags=["companies"])


@router.get("/{company_id}")
def get_company(company_id: int):
    company = query("SELECT * FROM companies WHERE id = %s", (company_id,))[0]

    # anti-padrão: parse manual do array-em-texto. Se cluster_ids for NULL, quebra aqui.
    raw = company["cluster_ids"].strip("{}")            # AttributeError se NULL -> "campos nulos"
    ids = [c for c in raw.split(",") if c]

    personas = query(
        "SELECT * FROM personas WHERE external_id = ANY(%s) AND language = 'pt'",
        (ids,),
    )

    # a tela de empresa também agrega os usuários -> se isso falhar, "a empresa inteira quebra"
    users = query("SELECT id, email, name, status FROM users WHERE company_id = %s", (company_id,))

    return {"company": company, "personas": personas, "users": users}


@router.get("/{company_id}/users")
def get_company_users(company_id: int):
    return query("SELECT id, email, name, status FROM users WHERE company_id = %s", (company_id,))
