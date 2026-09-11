-- 僅允許網站匿名讀取已啟用的 P124 資料。
drop policy if exists "PolP124CategoryPublicRead" on public."TblP124Category";
create policy "PolP124CategoryPublicRead"
  on public."TblP124Category"
  for select
  to anon, authenticated
  using ("IsActive" = true);

drop policy if exists "PolP124QuestionPublicRead" on public."TblP124Question";
create policy "PolP124QuestionPublicRead"
  on public."TblP124Question"
  for select
  to anon, authenticated
  using (
    "IsActive" = true
    and exists (
      select 1
      from public."TblP124Category" c
      where c."CategoryID" = "TblP124Question"."CategoryID"
        and c."IsActive" = true
    )
  );
