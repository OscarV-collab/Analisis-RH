-- Ejecuta este script completo una sola vez en Supabase: SQL Editor > New query > Run.
create table if not exists public.estudios_registros (id text primary key, payload jsonb not null, updated_at timestamptz not null default now());
create table if not exists public.estudios_catalogo (id text primary key, payload jsonb not null, updated_at timestamptz not null default now());
create table if not exists public.profiles (id uuid primary key references auth.users(id) on delete cascade, name text not null default '', email text not null default '', role text not null default 'RH' check (role in ('ADMIN','RH')), active boolean not null default true, created_at timestamptz not null default now());

create or replace function public.handle_new_user() returns trigger language plpgsql security definer set search_path = public as $$ begin insert into public.profiles(id,name,email) values (new.id,coalesce(new.raw_user_meta_data->>'name',''),coalesce(new.email,'')) on conflict (id) do nothing; return new; end; $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();

create or replace function public.is_admin() returns boolean language sql stable security definer set search_path = public as $$ select exists (select 1 from public.profiles where id = auth.uid() and role = 'ADMIN' and active = true); $$;
alter table public.estudios_registros enable row level security;
alter table public.estudios_catalogo enable row level security;
alter table public.profiles enable row level security;
drop policy if exists "Lectura pública de estudios" on public.estudios_registros; drop policy if exists "Escritura pública de estudios" on public.estudios_registros; drop policy if exists "Actualización pública de estudios" on public.estudios_registros; drop policy if exists "Eliminación pública de estudios" on public.estudios_registros;
drop policy if exists "Lectura pública de catálogo" on public.estudios_catalogo; drop policy if exists "Escritura pública de catálogo" on public.estudios_catalogo; drop policy if exists "Actualización pública de catálogo" on public.estudios_catalogo; drop policy if exists "Eliminación pública de catálogo" on public.estudios_catalogo;
drop policy if exists "Usuarios autenticados ven estudios" on public.estudios_registros; drop policy if exists "Usuarios autenticados crean estudios" on public.estudios_registros; drop policy if exists "Usuarios autenticados actualizan estudios" on public.estudios_registros; drop policy if exists "Administradores eliminan estudios" on public.estudios_registros;
drop policy if exists "Usuarios autenticados ven catálogo" on public.estudios_catalogo; drop policy if exists "Administradores gestionan catálogo" on public.estudios_catalogo;
drop policy if exists "Usuario ve su perfil" on public.profiles;
create policy "Usuarios autenticados ven estudios" on public.estudios_registros for select to authenticated using (true);
create policy "Usuarios autenticados crean estudios" on public.estudios_registros for insert to authenticated with check (true);
create policy "Usuarios autenticados actualizan estudios" on public.estudios_registros for update to authenticated using (true) with check (true);
create policy "Administradores eliminan estudios" on public.estudios_registros for delete to authenticated using (public.is_admin());
create policy "Usuarios autenticados ven catálogo" on public.estudios_catalogo for select to authenticated using (true);
create policy "Administradores gestionan catálogo" on public.estudios_catalogo for all to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "Usuario ve su perfil" on public.profiles for select to authenticated using (id = auth.uid());

-- Después de crear tu primer usuario en Authentication > Users, conviértelo en administrador:
-- update public.profiles set role = 'ADMIN' where email = 'TU_CORREO_ADMINISTRADOR';
