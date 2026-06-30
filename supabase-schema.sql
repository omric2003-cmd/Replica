-- Dubbing Prep — Supabase schema
-- Run this in your Supabase project: SQL Editor → New query → paste → Run.
-- Creates the encrypted projects table and locks it down with row-level
-- security so each user can only ever read or write their own rows.
-- Note: the server only ever stores ciphertext + iv. It cannot read script content.

create table if not exists public.projects (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references auth.users (id) on delete cascade,
  iv          text not null,            -- AES-GCM initialisation vector (base64)
  ciphertext  text not null,            -- encrypted {fileName, pageCount, rows, savedAt} (base64)
  updated_at  timestamptz not null default now(),
  created_at  timestamptz not null default now()
);

create index if not exists projects_user_idx on public.projects (user_id, updated_at desc);

-- Row-level security: a user sees and edits only their own projects.
alter table public.projects enable row level security;

drop policy if exists "own_select" on public.projects;
create policy "own_select" on public.projects
  for select using (auth.uid() = user_id);

drop policy if exists "own_insert" on public.projects;
create policy "own_insert" on public.projects
  for insert with check (auth.uid() = user_id);

drop policy if exists "own_update" on public.projects;
create policy "own_update" on public.projects
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "own_delete" on public.projects;
create policy "own_delete" on public.projects
  for delete using (auth.uid() = user_id);
