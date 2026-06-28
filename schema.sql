-- ============================================================
-- NINHO CONSULTORIA — Diagnóstico de Aptidão Financeira
-- Schema para o Supabase (rodar no SQL Editor do seu projeto)
-- ============================================================

-- ============================================================
-- Tabela: pessoas
-- Cadastro de quem vai responder o questionário. Cada pessoa
-- tem um token único que vira parte do link pessoal dela.
-- ============================================================
create table if not exists public.pessoas (
  id uuid primary key default gen_random_uuid(),
  criado_em timestamptz not null default now(),
  nome text not null,
  email text not null,
  token text not null unique default replace(gen_random_uuid()::text, '-', '')
);

create index if not exists pessoas_token_idx on public.pessoas (token);
create index if not exists pessoas_criado_em_idx on public.pessoas (criado_em desc);

-- ============================================================
-- Tabela: respostas
-- Cada envio do questionário, vinculado a uma pessoa.
-- Uma pessoa pode ter várias respostas (diagnóstico recorrente).
-- ============================================================
create table if not exists public.respostas (
  id uuid primary key default gen_random_uuid(),
  criado_em timestamptz not null default now(),

  pessoa_id uuid not null references public.pessoas(id) on delete cascade,

  -- Respostas das 7 perguntas de aptidão (cada uma vale 1 a 4 pontos)
  p1 smallint not null check (p1 between 1 and 4),
  p2 smallint not null check (p2 between 1 and 4),
  p3 smallint not null check (p3 between 1 and 4),
  p4 smallint not null check (p4 between 1 and 4),
  p5 smallint not null check (p5 between 1 and 4),
  p6 smallint not null check (p6 between 1 and 4),
  p7 smallint not null check (p7 between 1 and 4),

  -- Pontuação total (7 a 28) e perfil calculado, gravados no envio
  pontuacao smallint not null check (pontuacao between 7 and 28),
  perfil text not null
);

create index if not exists respostas_pessoa_id_idx on public.respostas (pessoa_id);
create index if not exists respostas_criado_em_idx on public.respostas (criado_em desc);

-- ============================================================
-- Row Level Security
-- ============================================================
alter table public.pessoas enable row level security;
alter table public.respostas enable row level security;

-- PESSOAS:
-- Qualquer visitante (anon) pode LER pessoas — necessário para o
-- questionário público confirmar o token e mostrar o nome da pessoa.
create policy "Permitir leitura publica de pessoas"
  on public.pessoas
  for select
  to anon
  using (true);

-- Apenas autenticados (você, no admin) podem CRIAR novas pessoas
create policy "Permitir insercao de pessoas para autenticados"
  on public.pessoas
  for insert
  to authenticated
  with check (true);

-- Apenas autenticados podem EXCLUIR pessoas
create policy "Permitir delecao de pessoas para autenticados"
  on public.pessoas
  for delete
  to authenticated
  using (true);

-- RESPOSTAS:
-- Qualquer visitante pode INSERIR uma resposta (envio do formulário)
create policy "Permitir insercao publica de respostas"
  on public.respostas
  for insert
  to anon
  with check (true);

-- Apenas autenticados podem LER respostas (painel admin)
create policy "Permitir leitura de respostas para autenticados"
  on public.respostas
  for select
  to authenticated
  using (true);

-- Apenas autenticados podem EXCLUIR respostas
create policy "Permitir delecao de respostas para autenticados"
  on public.respostas
  for delete
  to authenticated
  using (true);

-- ============================================================
-- Próximos passos no painel do Supabase:
-- 1. Project Settings > API → confirme que SUPABASE_URL e
--    SUPABASE_ANON_KEY já estão corretos nos arquivos HTML.
-- 2. Authentication > Users → crie seu usuário admin, se ainda
--    não tiver feito isso.
-- ============================================================
