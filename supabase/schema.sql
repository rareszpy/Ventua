-- Ventua database setup. Paste all of this into Supabase: SQL Editor -> New query -> Run.
-- Safe to run more than once.

-- One table holds every page, event and habit. Each row belongs to one user.
create table if not exists public.items (
  user_id  uuid    not null default auth.uid() references auth.users (id) on delete cascade,
  key      text    not null check (char_length(key) between 3 and 80),   -- e.g. "page_abc123"
  kind     text    not null check (kind in ('page', 'event', 'habit')),
  data     jsonb   not null default '{}'::jsonb check (pg_column_size(data) < 300000),
  updated  bigint  not null,                                             -- ms timestamp, last write wins
  deleted  boolean not null default false,                               -- tombstone so deletes sync too
  primary key (user_id, key)
);
create index if not exists items_user_updated on public.items (user_id, updated);

-- Row Level Security: people can only ever see and change their own rows.
alter table public.items enable row level security;

drop policy if exists "items: read own"   on public.items;
drop policy if exists "items: insert own" on public.items;
drop policy if exists "items: update own" on public.items;
drop policy if exists "items: delete own" on public.items;
create policy "items: read own"   on public.items for select to authenticated using ((select auth.uid()) = user_id);
create policy "items: insert own" on public.items for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "items: update own" on public.items for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "items: delete own" on public.items for delete to authenticated using ((select auth.uid()) = user_id);

revoke all on public.items from anon;
grant select, insert, update, delete on public.items to authenticated;

-- Live sync: other open devices hear about changes instantly.
do $$ begin
  alter publication supabase_realtime add table public.items;
exception when duplicate_object then null;
end $$;
