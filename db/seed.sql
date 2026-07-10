-- Dados 100% fictícios, sujos de propósito.

-- Empresas: uma com cluster_ids inconsistente, uma com cluster_ids NULL (quebra a tela)
INSERT INTO companies (id, name, cluster_ids, project_name, status) VALUES
(1, 'Aurora Cosmetics', '{CL_1023,CL_1044,CL_1050}', 'Skincare 2024', 'active'),
(2, 'Vega Retail',      NULL,                          NULL,           'active'),
(3, 'Nimbus Finance',   '{CL_2001}',                   'Cartoes',      'active');

-- Personas: mesma persona em 4 idiomas = 4 linhas; project_name divergente entre idiomas
INSERT INTO personas (external_id, language, title, description, avatar_url, tags, project_name) VALUES
('CL_1023','pt','Consumidora Skincare','Foco em skincare','http://x/a.png','skincare','Skincare 2024'),
('CL_1023','en','Skincare Shopper',    'Skincare focused','http://x/a.png','skincare','Skincare 2024'),
('CL_1023','es','Compradora Skincare', 'Enfoque skincare', 'http://x/a.png','skincare','Skincare 24'),   -- divergente
('CL_1023','fr','Acheteuse Soin',      'Axe soin',         'http://x/a.png','soin',    NULL),             -- NULL divergente
('CL_1044','pt','Consumidora Hair',    'Foco em cabelo',   'http://x/b.png','hair',    'Hair 2024'),
('CL_1044','en','Hair Shopper',        NULL,               'http://x/b.png','hair',    'Hair 2024'),      -- description NULL
('CL_1050','pt','Consumidora Makeup',  'Foco em maquiagem','http://x/c.png','makeup',  'Makeup 2024'),
('CL_2001','pt','Investidor Cartao',   'Cartoes premium',  'http://x/d.png','finance', 'Cartoes');

-- Usuários: um sem empresa (company_id NULL), um admin interno multi-conta, um comum
INSERT INTO users (id, email, name, company_id, status, role) VALUES
(1, 'ana@aurora.example',   'Ana Lima',      1,    'active',           'user'),
(2, 'sem-empresa@x.example','Sem Empresa',   NULL, 'active',           'user'),   -- não usa features que exigem empresa
(3, 'ops@galaxies.example', 'Op Interno',    NULL, 'active',           'admin'),  -- transita por várias contas
(4, 'joao@vega.example',    'Joao Souza',    2,    'pending_approval', 'user');   -- preso aguardando aprovação

-- user_clusters: DIVERGE do cluster_ids da empresa; admin interno tem clusters de 2 empresas
INSERT INTO user_clusters (user_id, cluster_id) VALUES
(1, '{CL_1023,CL_9999}'),            -- CL_9999 NÃO está na empresa 1: qual fonte vence?
(3, '{CL_1023,CL_2001}');            -- admin interno: clusters de Aurora + Nimbus (bug do delete+reinsert)

-- whitelist: e-mail pré-aprovado SEM conta criada (limbo)
INSERT INTO whitelist (email, company_id, approved) VALUES
('novato@aurora.example', 1, true),  -- aprovado mas não existe user -> "aguardando aprovacao"
('ana@aurora.example',    1, true);  -- e-mail JÁ existente -> causa 400 ao tentar recriar

-- report_configs: 5º lugar onde persona aparece (JSON em texto)
INSERT INTO report_configs (company_id, persona_refs) VALUES
(1, '["CL_1023","CL_1044"]'),
(3, '["CL_2001"]');

-- Legado órfão
INSERT INTO templates (name, body) VALUES ('welcome', 'Ola {nome}');
INSERT INTO control_group (label, note) VALUES ('grupo_controle_v1', 'provavelmente nao faz mais nada');

-- Ressincroniza as sequences após inserts com id explícito
SELECT setval('companies_id_seq', (SELECT max(id) FROM companies));
SELECT setval('users_id_seq',     (SELECT max(id) FROM users));
