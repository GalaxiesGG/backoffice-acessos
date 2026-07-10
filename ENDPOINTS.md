# Endpoints (mapeamento parcial)

> ⚠️ Lista **incompleta**. Documenta só o que alguém anotou até hoje.
> Mapear o resto faz parte do trabalho.

| Método | Rota | O que faz (segundo quem anotou) |
|--------|------|--------------------------------|
| GET  | `/companies/{id}`        | Abre a tela da empresa (dados + personas + usuários) |
| GET  | `/companies/{id}/users`  | Lista usuários da empresa |
| POST | `/users`                 | Cria usuário |
| GET  | `/personas`              | Busca personas (filtro por `q` e `language`) |

_(há mais rotas em `app/routers/` que ninguém documentou)_
