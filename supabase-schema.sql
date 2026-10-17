create table if not exists public.inventario_state (
  user_id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.inventario_state enable row level security;

create policy "Users can read their inventory state"
  on public.inventario_state
  for select
  to authenticated
  using (auth.uid() = user_id);

create policy "Users can insert their inventory state"
  on public.inventario_state
  for insert
  to authenticated
  with check (auth.uid() = user_id);

create policy "Users can update their inventory state"
  on public.inventario_state
  for update
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
