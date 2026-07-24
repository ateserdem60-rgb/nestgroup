-- NEST GROUP PIN ADMIN - SUPABASE SETUP
-- Supabase > SQL Editor > New Query alanında TAMAMINI çalıştırın.
-- İlk yönetim PIN'i: 4747

create extension if not exists pgcrypto;

create table if not exists public.properties (
  id uuid primary key default gen_random_uuid(),
  listing_no text unique,
  title text not null,
  description text,
  type text not null default 'Satılık',
  status text not null default 'Aktif',
  price numeric,
  city text default 'Mardin',
  district text default 'Midyat',
  neighborhood text,
  rooms text,
  gross_m2 numeric,
  floor text,
  heating text,
  cover_url text,
  featured boolean not null default false,
  published boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.admin_settings (
  id integer primary key default 1 check (id = 1),
  pin_hash text not null,
  updated_at timestamptz not null default now()
);

insert into public.admin_settings(id, pin_hash)
values (1, crypt('4747', gen_salt('bf')))
on conflict (id) do nothing;

alter table public.properties enable row level security;
alter table public.admin_settings enable row level security;

drop policy if exists "Public view published properties" on public.properties;
create policy "Public view published properties"
on public.properties for select to anon, authenticated
using (published = true);

-- Do not expose admin_settings directly.
revoke all on public.admin_settings from anon, authenticated;

create or replace function public.verify_admin_pin(entered_pin text)
returns boolean
language sql
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.admin_settings
    where id = 1 and pin_hash = crypt(entered_pin, pin_hash)
  );
$$;

create or replace function public.change_admin_pin(current_pin text, new_pin text)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
begin
  if new_pin !~ '^[0-9]{4}$' then
    raise exception 'PIN tam 4 rakam olmalıdır';
  end if;

  if not public.verify_admin_pin(current_pin) then
    return false;
  end if;

  update public.admin_settings
  set pin_hash = crypt(new_pin, gen_salt('bf')), updated_at = now()
  where id = 1;
  return true;
end;
$$;

grant execute on function public.verify_admin_pin(text) to anon, authenticated;
grant execute on function public.change_admin_pin(text,text) to anon, authenticated;

-- NOTE:
-- Bu kolay PIN sürümünde ilan yazma işlemlerinin güvenli şekilde yapılabilmesi için
-- sonraki aşamada CRUD işlemleri de PIN doğrulayan RPC fonksiyonlarına taşınmalıdır.
-- Şimdilik mevcut admin CRUD yapınız Supabase Auth politikalarıyla çalışıyorsa onları koruyun.

insert into storage.buckets (id, name, public)
values ('property-images','property-images',true)
on conflict (id) do update set public = true;

drop policy if exists "Public read property images" on storage.objects;
create policy "Public read property images"
on storage.objects for select to public
using (bucket_id = 'property-images');
