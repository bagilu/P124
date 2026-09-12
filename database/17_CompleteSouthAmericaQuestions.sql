-- P124 題庫增量：完成南美洲分類 12 個主權國家題目。
-- 適用於已建立 SOUTH_AMERICA_COUNTRIES 分類的資料庫；可重複執行。
-- 答案限於本分類候選項目；法屬圭亞那等海外領地不作為獨立國家。
-- 本檔僅操作 P124 專屬資料表，不會影響其他專案。

begin;

do $$
begin
  if not exists (
    select 1
    from public."TblP124Category"
    where "CategoryCode" = 'SOUTH_AMERICA_COUNTRIES'
  ) then
    raise exception '找不到 P124 分類 SOUTH_AMERICA_COUNTRIES，請先執行 database/11_AddAfricaAsiaSouthAmericaSamples.sql。';
  end if;
end
$$;

update public."TblP124Category"
set
  "DescriptionZh" = '南美洲分類12個主權國家之間的陸地接壤關係',
  "DescriptionEn" = 'Land-border relationships among 12 sovereign countries in South America',
  "UpdatedAt" = now()
where "CategoryCode" = 'SOUTH_AMERICA_COUNTRIES';

-- CorrectItemIDs：本分類內全部正確的陸地鄰國。
-- DistractorItemIDs：地理位置較近、但不直接接壤的人工誘答。
insert into public."TblP124Question" (
  "CategoryID", "TargetItemID", "CorrectItemIDs", "DistractorItemIDs", "IsActive"
)
select
  c."CategoryID",
  q."TargetItemID",
  q."CorrectItemIDs",
  q."DistractorItemIDs",
  true
from public."TblP124Category" c
cross join (
  values
    ('SA-AR', '["SA-BO","SA-BR","SA-CL","SA-PY","SA-UY"]'::jsonb, '["SA-PE","SA-EC","SA-CO","SA-VE","SA-GY","SA-SR"]'::jsonb),
    ('SA-BO', '["SA-AR","SA-BR","SA-CL","SA-PE","SA-PY"]'::jsonb, '["SA-EC","SA-CO","SA-VE","SA-GY","SA-SR","SA-UY"]'::jsonb),
    ('SA-BR', '["SA-AR","SA-BO","SA-CO","SA-GY","SA-PE","SA-PY","SA-SR","SA-UY","SA-VE"]'::jsonb, '["SA-CL","SA-EC"]'::jsonb),
    ('SA-CL', '["SA-AR","SA-BO","SA-PE"]'::jsonb, '["SA-EC","SA-PY","SA-UY","SA-BR","SA-CO","SA-VE"]'::jsonb),
    ('SA-CO', '["SA-BR","SA-EC","SA-PE","SA-VE"]'::jsonb, '["SA-GY","SA-BO","SA-SR","SA-PY","SA-CL","SA-AR"]'::jsonb),
    ('SA-EC', '["SA-CO","SA-PE"]'::jsonb, '["SA-BO","SA-BR","SA-CL","SA-VE","SA-GY","SA-PY"]'::jsonb),
    ('SA-GY', '["SA-BR","SA-SR","SA-VE"]'::jsonb, '["SA-CO","SA-EC","SA-PE","SA-BO","SA-PY","SA-UY"]'::jsonb),
    ('SA-PE', '["SA-BO","SA-BR","SA-CL","SA-CO","SA-EC"]'::jsonb, '["SA-AR","SA-PY","SA-VE","SA-GY","SA-SR","SA-UY"]'::jsonb),
    ('SA-PY', '["SA-AR","SA-BO","SA-BR"]'::jsonb, '["SA-UY","SA-CL","SA-PE","SA-CO","SA-VE","SA-EC"]'::jsonb),
    ('SA-SR', '["SA-BR","SA-GY"]'::jsonb, '["SA-VE","SA-CO","SA-EC","SA-PE","SA-BO","SA-PY"]'::jsonb),
    ('SA-UY', '["SA-AR","SA-BR"]'::jsonb, '["SA-PY","SA-CL","SA-BO","SA-PE","SA-EC","SA-CO"]'::jsonb),
    ('SA-VE', '["SA-BR","SA-CO","SA-GY"]'::jsonb, '["SA-EC","SA-SR","SA-PE","SA-BO","SA-PY","SA-AR"]'::jsonb)
) as q("TargetItemID", "CorrectItemIDs", "DistractorItemIDs")
where c."CategoryCode" = 'SOUTH_AMERICA_COUNTRIES'
on conflict ("CategoryID", "TargetItemID") do update set
  "CorrectItemIDs" = excluded."CorrectItemIDs",
  "DistractorItemIDs" = excluded."DistractorItemIDs",
  "IsActive" = excluded."IsActive",
  "UpdatedAt" = now();

commit;

-- 執行結果應為：QuestionCount = 12、ActiveQuestionCount = 12。
select
  c."CategoryCode",
  c."CategoryNameZh",
  count(q."QuestionID") as "QuestionCount",
  count(q."QuestionID") filter (where q."IsActive") as "ActiveQuestionCount"
from public."TblP124Category" c
left join public."TblP124Question" q
  on q."CategoryID" = c."CategoryID"
where c."CategoryCode" = 'SOUTH_AMERICA_COUNTRIES'
group by c."CategoryCode", c."CategoryNameZh";
