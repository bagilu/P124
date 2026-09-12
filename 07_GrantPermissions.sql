-- 精確限定 P124 的兩張資料表，不使用 public schema 全域授權。
grant select on table public."TblP124Category" to anon, authenticated;
grant select on table public."TblP124Question" to anon, authenticated;

revoke insert, update, delete, truncate, references, trigger
  on table public."TblP124Category" from anon, authenticated;
revoke insert, update, delete, truncate, references, trigger
  on table public."TblP124Question" from anon, authenticated;
