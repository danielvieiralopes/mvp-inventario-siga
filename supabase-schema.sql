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

insert into storage.buckets (id, name, public)
values ('closing-documents', 'closing-documents', false)
on conflict (id) do nothing;

create policy "Users can read their closing documents"
  on storage.objects
  for select
  to authenticated
  using (
    bucket_id = 'closing-documents'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "Users can upload their closing documents"
  on storage.objects
  for insert
  to authenticated
  with check (
    bucket_id = 'closing-documents'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "Users can update their closing documents"
  on storage.objects
  for update
  to authenticated
  using (
    bucket_id = 'closing-documents'
    and (storage.foldername(name))[1] = auth.uid()::text
  )
  with check (
    bucket_id = 'closing-documents'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "Users can delete their closing documents"
  on storage.objects
  for delete
  to authenticated
  using (
    bucket_id = 'closing-documents'
    and (storage.foldername(name))[1] = auth.uid()::text
  );
