supabase_sql = textwrap.dedent("""\
-- Table responses: store each submission as one row with JSONB data
create table if not exists responses (
  id uuid primary key default uuid_generate_v4(),
  client text,
  data jsonb,
  created_at timestamp with time zone default now()
);

-- Table admins: list of admin emails (optional)
create table if not exists admins (
  id uuid primary key default uuid_generate_v4(),
  email text unique not null,
  created_at timestamp with time zone default now()
);

-- Enable row level security on responses (recommended)
alter table responses enable row level security;

-- Policy: allow anonymous insert (for public frontend). Only use if acceptable.
create policy if not exists "allow anon insert" on responses
  for insert
  to anon
  with check (true);

-- Example policy: allow authenticated admins to select
create policy if not exists "admins can select" on responses
  for select
  using (auth.role() = 'authenticated' and exists (select 1 from admins where admins.email = auth.email()));
""")
