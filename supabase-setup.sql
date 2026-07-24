-- NEST GROUP / SUPABASE
-- Supabase > SQL Editor > New query bölümünde bir kez çalıştırın.

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

alter table public.properties enable row level security;

drop policy if exists "Public view published properties" on public.properties;
create policy "Public view published properties"
on public.properties for select
to anon, authenticated
using (published = true or auth.role() = 'authenticated');

drop policy if exists "Authenticated insert properties" on public.properties;
create policy "Authenticated insert properties"
on public.properties for insert
to authenticated
with check (true);

drop policy if exists "Authenticated update properties" on public.properties;
create policy "Authenticated update properties"
on public.properties for update
to authenticated
using (true)
with check (true);

drop policy if exists "Authenticated delete properties" on public.properties;
create policy "Authenticated delete properties"
on public.properties for delete
to authenticated
using (true);

insert into storage.buckets (id, name, public)
values ('property-images','property-images',true)
on conflict (id) do update set public = true;

drop policy if exists "Public read property images" on storage.objects;
create policy "Public read property images"
on storage.objects for select
to public
using (bucket_id = 'property-images');

drop policy if exists "Authenticated upload property images" on storage.objects;
create policy "Authenticated upload property images"
on storage.objects for insert
to authenticated
with check (bucket_id = 'property-images');

drop policy if exists "Authenticated update property images" on storage.objects;
create policy "Authenticated update property images"
on storage.objects for update
to authenticated
using (bucket_id = 'property-images')
with check (bucket_id = 'property-images');

drop policy if exists "Authenticated delete property images" on storage.objects;
create policy "Authenticated delete property images"
on storage.objects for delete
to authenticated
using (bucket_id = 'property-images');
