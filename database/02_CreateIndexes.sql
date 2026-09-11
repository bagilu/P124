-- P124 專屬索引
create index if not exists "IdxP124CategoryActiveSort"
  on public."TblP124Category" ("IsActive", "SortOrder");

create index if not exists "IdxP124QuestionCategoryActive"
  on public."TblP124Question" ("CategoryID", "IsActive");
