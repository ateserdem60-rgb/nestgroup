create extension if not exists "pgcrypto";

create table if not exists public.properties (
  id uuid primary key default gen_random_uuid(),
  listing_no text unique not null,
  slug text unique not null,
  title text not null,
  status text not null check (status in ('satilik','kiralik','satildi','kiralandi')),
  property_type text not null,
  price numeric(14,2) not null default 0,
  price_suffix text,
  city text not null default 'Mardin',
  district text not null default 'Midyat',
  neighborhood text,
  rooms text,
  gross_m2 numeric,
  net_m2 numeric,
  floor text,
  building_age text,
  heating text,
  facade text,
  balcony boolean default false,
  parking boolean default false,
  furnished boolean default false,
  featured boolean default false,
  published boolean default true,
  description text,
  features text[] default '{}',
  latitude numeric,
  longitude numeric,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.property_images (
  id uuid primary key default gen_random_uuid(),
  property_id uuid not null references public.properties(id) on delete cascade,
  image_url text not null,
  sort_order integer default 0,
  is_cover boolean default false,
  created_at timestamptz default now()
);

create table if not exists public.leads (
  id uuid primary key default gen_random_uuid(),
  name text,
  phone text,
  property_type text,
  intent text,
  budget text,
  location text,
  notes text,
  created_at timestamptz default now()
);

alter table public.properties enable row level security;
alter table public.property_images enable row level security;
alter table public.leads enable row level security;

create policy "public can view published properties" on public.properties for select using (published = true);
create policy "public can view property images" on public.property_images for select using (true);
create policy "public can submit leads" on public.leads for insert with check (true);
