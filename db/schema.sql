-- Estado ATUAL do backoffice de gestão de acessos.
-- Intencionalmente bagunçado. Ponto de partida do case, NÃO um modelo a seguir.

CREATE TABLE companies (
    id           SERIAL PRIMARY KEY,
    name         TEXT NOT NULL,
    -- anti-padrão: IDs de personas/clusters guardados como array em texto
    cluster_ids  TEXT,                 -- ex.: '{CL_1023,CL_1044}'  (pode vir NULL)
    project_name TEXT,                 -- cicatriz: cliente tem vários projetos, cabe um só
    status       TEXT DEFAULT 'active',
    created_at   TIMESTAMP DEFAULT now()
);

CREATE TABLE users (
    id         SERIAL PRIMARY KEY,
    email      TEXT UNIQUE NOT NULL,
    name       TEXT,
    company_id INTEGER,                -- anti-padrão: NULÁVEL (usuários sem empresa)
    status     TEXT DEFAULT 'active',  -- texto livre: 'active' | 'pending_approval'
    role       TEXT DEFAULT 'user',    -- texto livre: 'user' | 'admin' (interno)
    created_at TIMESTAMP DEFAULT now()
);

CREATE TABLE personas (
    id           SERIAL PRIMARY KEY,
    external_id  TEXT NOT NULL,        -- 'CL_xxxx' usado como texto no resto do sistema (NÃO é FK)
    language     TEXT NOT NULL,        -- 'pt' | 'en' | 'es' | 'fr' — cada idioma é uma linha
    title        TEXT,
    description  TEXT,
    avatar_url   TEXT,
    tags         TEXT,
    project_name TEXT                  -- duplicado; às vezes divergente entre os 4 idiomas
);

CREATE TABLE user_clusters (
    id         SERIAL PRIMARY KEY,
    user_id    INTEGER NOT NULL,
    -- anti-padrão: array de TODOS os clusters do usuário como texto; edição faz delete+reinsert (sem histórico)
    cluster_id TEXT,                   -- ex.: '{CL_1023,CL_1044}'
    updated_at TIMESTAMP DEFAULT now()
);

CREATE TABLE whitelist (
    id         SERIAL PRIMARY KEY,
    email      TEXT NOT NULL,
    company_id INTEGER,
    approved   BOOLEAN DEFAULT false,  -- pré-aprova mas NÃO cria a conta
    created_at TIMESTAMP DEFAULT now()
);

-- 5º lugar onde persona aparece (o brief só cita 4)
CREATE TABLE report_configs (
    id           SERIAL PRIMARY KEY,
    company_id   INTEGER,
    persona_refs TEXT                  -- JSON em texto: '["CL_1023","CL_1044"]'
);

-- Legado/órfão — red herrings de escopo
CREATE TABLE templates (
    id      SERIAL PRIMARY KEY,
    name    TEXT,
    body    TEXT
);

CREATE TABLE control_group (
    id       SERIAL PRIMARY KEY,
    label    TEXT,
    note     TEXT
);
