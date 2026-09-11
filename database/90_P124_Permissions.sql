-- 可重複執行的 P124 權限修復檔；不修改其他專案。
alter table public."TblP124Category" enable row level security;
alter table public."TblP124Question" enable row level security;

grant select on table public."TblP124Category" to anon, authenticated;
grant select on table public."TblP124Question" to anon, authenticated;
