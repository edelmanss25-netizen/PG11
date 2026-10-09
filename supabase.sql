-- ФОРМАТ · таблицы для синхронизации. Выполнить один раз: Supabase → SQL Editor → New query → Run.

create table if not exists public.planner_settings (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  state      jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

create table if not exists public.planner_days (
  user_id    uuid not null references auth.users(id) on delete cascade,
  day        text not null,                       -- 'YYYY-MM-DD'
  events     jsonb not null default '[]'::jsonb,  -- встречи дня
  plan       jsonb,                               -- план дня: направления, задачи, продажи
  updated_at timestamptz not null default now(),
  primary key (user_id, day)
);

-- Каждый видит и меняет только свои строки
alter table public.planner_settings enable row level security;
alter table public.planner_days     enable row level security;

drop policy if exists "own settings" on public.planner_settings;
create policy "own settings" on public.planner_settings
  for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists "own days" on public.planner_days;
create policy "own days" on public.planner_days
  for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());

-- Живое обновление между устройствами
do $$ begin
  alter publication supabase_realtime add table public.planner_days;
exception when duplicate_object then null; end $$;
do $$ begin
  alter publication supabase_realtime add table public.planner_settings;
exception when duplicate_object then null; end $$;
