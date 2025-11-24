create table responses (
  id uuid primary key default gen_random_uuid(),
  client_id text not null,
  submitted_at timestamptz default now(),
  data jsonb not null
);

-- autoriser l'insert depuis GitHub Pages (public)
-- (On renforcera plus tard avec RLS + edge function)
alter table responses enable row level security;
create policy "public_insert" on responses
for insert
to anon
with check (true);
