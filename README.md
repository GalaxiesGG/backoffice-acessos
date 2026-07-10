# Backoffice de Gestão de Acessos — recorte do estado atual

> ⚠️ **Esta base é intencionalmente bagunçada.** É o ponto de partida do case,
> **não** um modelo a seguir. Todos os dados são **100% fictícios**.

Recorte fictício, porém realista, do backoffice de gestão de acessos (Galaxies / Nexus)
no estado atual — o "Frankenstein". Serve de âncora concreta para o diagnóstico e a proposta.

## Como rodar

Requisito: Docker.

```bash
cp .env.example .env
docker compose up --build
```

- API + Swagger: http://localhost:8000/docs
- O Postgres já sobe com `db/schema.sql` e `db/seed.sql` aplicados.

## Mapa de pastas

- `db/schema.sql` — estado atual do banco (com os anti-padrões).
- `db/seed.sql` — amostra de dados sujos.
- `app/` — FastAPI. SQL cru direto nas tabelas (sem ORM), de propósito.
- `ENDPOINTS.md` — lista parcial de endpoints (incompleta de propósito).
- `KNOWN_ISSUES.md` — sintomas como a operação relata.

## O que este repo é (e não é)

- **É:** base concreta pra você diagnosticar, modelar e planejar.
- **Não é:** solução, referência de arquitetura, nem código para copiar.

Não precisa estar deployável em produção; precisa subir localmente e ser legível.
