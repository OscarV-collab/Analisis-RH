-- Ejecuta este archivo una sola vez en Supabase: SQL Editor > New query > Run.
create table if not exists public.estudios_registros (
  id text primary key,
  payload jsonb not null,
  updated_at timestamptz not null default now()
);

create table if not exists public.estudios_catalogo (
  id text primary key,
  payload jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.estudios_registros enable row level security;
alter table public.estudios_catalogo enable row level security;

create policy "Lectura pública de estudios" on public.estudios_registros for select using (true);
create policy "Escritura pública de estudios" on public.estudios_registros for insert with check (true);
create policy "Actualización pública de estudios" on public.estudios_registros for update using (true) with check (true);
create policy "Eliminación pública de estudios" on public.estudios_registros for delete using (true);

create policy "Lectura pública de catálogo" on public.estudios_catalogo for select using (true);
create policy "Escritura pública de catálogo" on public.estudios_catalogo for insert with check (true);
create policy "Actualización pública de catálogo" on public.estudios_catalogo for update using (true) with check (true);
create policy "Eliminación pública de catálogo" on public.estudios_catalogo for delete using (true);
