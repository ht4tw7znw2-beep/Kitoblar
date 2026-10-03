-- Supabase > SQL Editor: RUN (setup.sql dan keyin)
alter table catalog add column if not exists img text, add column if not exists old numeric;
alter table orders add column if not exists pay text default 'Naqd', add column if not exists wallet_use numeric default 0;
create table if not exists wallets(phone text primary key, name text, balance numeric not null default 0, updated_at timestamptz default now());
alter table wallets enable row level security;
create policy "wallet admin" on wallets for all to authenticated using(true) with check(true);
create or replace function get_balance(p_phone text) returns numeric language sql security definer as $$ select coalesce((select balance from wallets where phone=p_phone),0) $$;
grant execute on function get_balance(text) to anon, authenticated;
create or replace function wallet_adjust(p_phone text,p_name text,p_delta numeric) returns numeric language plpgsql security definer as $$
declare b numeric;
begin
  insert into wallets(phone,name,balance) values(p_phone,p_name,greatest(p_delta,0))
  on conflict(phone) do update set balance=greatest(wallets.balance+p_delta,0),name=excluded.name,updated_at=now()
  returning balance into b;
  return b;
end $$;
revoke execute on function wallet_adjust(text,text,numeric) from public, anon;
grant execute on function wallet_adjust(text,text,numeric) to authenticated;
