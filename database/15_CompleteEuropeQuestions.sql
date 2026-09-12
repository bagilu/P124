-- P124 題庫增量：完成歐洲分類 43 國題目。
-- 適用於已建立 EUROPE_COUNTRIES 分類的資料庫；可重複執行。
-- 答案限於本分類候選項目；俄羅斯、科索沃、土耳其及跨洲海外領地不列入。
-- 本檔僅操作 P124 專屬資料表，不會影響其他專案。

begin;

do $$
begin
  if not exists (
    select 1
    from public."TblP124Category"
    where "CategoryCode" = 'EUROPE_COUNTRIES'
  ) then
    raise exception '找不到 P124 分類 EUROPE_COUNTRIES，請先執行 database/08_SeedData.sql。';
  end if;
end
$$;

-- 確保冰島與馬爾他可使用「無陸地相鄰國家」答案。
update public."TblP124Category"
set
  "DescriptionZh" = '歐洲分類43國之間的陸地接壤關係',
  "DescriptionEn" = 'Land-border relationships among 43 countries in the Europe category',
  "Items" = case
    when exists (
      select 1
      from jsonb_array_elements("Items") as item
      where item->>'id' = 'EU-NONE'
    ) then "Items"
    else "Items" || jsonb_build_array(
      jsonb_build_object(
        'id', 'EU-NONE',
        'zh', '無陸地相鄰國家',
        'en', 'No land-border neighbors'
      )
    )
  end,
  "UpdatedAt" = now()
where "CategoryCode" = 'EUROPE_COUNTRIES';

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
    ('EU-AD', '["EU-ES","EU-FR"]'::jsonb, '["EU-MC","EU-CH","EU-IT","EU-LI","EU-LU","EU-PT"]'::jsonb),
    ('EU-AL', '["EU-GR","EU-ME","EU-MK"]'::jsonb, '["EU-RS","EU-BA","EU-BG","EU-HR","EU-VA","EU-RO"]'::jsonb),
    ('EU-AT', '["EU-CH","EU-CZ","EU-DE","EU-HU","EU-IT","EU-LI","EU-SI","EU-SK"]'::jsonb, '["EU-HR","EU-SM","EU-BA","EU-PL","EU-RS","EU-VA"]'::jsonb),
    ('EU-BA', '["EU-HR","EU-ME","EU-RS"]'::jsonb, '["EU-SI","EU-HU","EU-MK","EU-AL","EU-SM","EU-AT"]'::jsonb),
    ('EU-BE', '["EU-DE","EU-FR","EU-LU","EU-NL"]'::jsonb, '["EU-CH","EU-LI","EU-GB","EU-DK","EU-CZ","EU-AT"]'::jsonb),
    ('EU-BG', '["EU-GR","EU-MK","EU-RO","EU-RS"]'::jsonb, '["EU-AL","EU-ME","EU-BA","EU-MD","EU-HU","EU-HR"]'::jsonb),
    ('EU-BY', '["EU-LT","EU-LV","EU-PL","EU-UA"]'::jsonb, '["EU-EE","EU-MD","EU-SK","EU-RO","EU-HU","EU-CZ"]'::jsonb),
    ('EU-CH', '["EU-AT","EU-DE","EU-FR","EU-IT","EU-LI"]'::jsonb, '["EU-MC","EU-LU","EU-BE","EU-SM","EU-SI","EU-NL"]'::jsonb),
    ('EU-CZ', '["EU-AT","EU-DE","EU-PL","EU-SK"]'::jsonb, '["EU-SI","EU-HU","EU-HR","EU-LI","EU-IT","EU-LU"]'::jsonb),
    ('EU-DE', '["EU-AT","EU-BE","EU-CH","EU-CZ","EU-DK","EU-FR","EU-LU","EU-NL","EU-PL"]'::jsonb, '["EU-LI","EU-SI","EU-IT","EU-SK","EU-HR","EU-SM"]'::jsonb),
    ('EU-DK', '["EU-DE"]'::jsonb, '["EU-NL","EU-NO","EU-BE","EU-LU","EU-GB","EU-CZ"]'::jsonb),
    ('EU-EE', '["EU-LV"]'::jsonb, '["EU-LT","EU-FI","EU-BY","EU-PL","EU-SE","EU-NO"]'::jsonb),
    ('EU-ES', '["EU-AD","EU-FR","EU-PT"]'::jsonb, '["EU-MC","EU-CH","EU-IT","EU-LI","EU-LU","EU-VA"]'::jsonb),
    ('EU-FI', '["EU-NO","EU-SE"]'::jsonb, '["EU-EE","EU-LV","EU-LT","EU-BY","EU-DK","EU-PL"]'::jsonb),
    ('EU-FR', '["EU-AD","EU-BE","EU-CH","EU-DE","EU-ES","EU-IT","EU-LU","EU-MC"]'::jsonb, '["EU-LI","EU-NL","EU-SM","EU-AT","EU-GB","EU-SI"]'::jsonb),
    ('EU-GB', '["EU-IE"]'::jsonb, '["EU-NL","EU-BE","EU-DK","EU-LU","EU-DE","EU-FR"]'::jsonb),
    ('EU-GR', '["EU-AL","EU-BG","EU-MK"]'::jsonb, '["EU-ME","EU-RS","EU-BA","EU-RO","EU-MT","EU-VA"]'::jsonb),
    ('EU-HR', '["EU-BA","EU-HU","EU-ME","EU-RS","EU-SI"]'::jsonb, '["EU-AT","EU-SM","EU-SK","EU-IT","EU-CZ","EU-VA"]'::jsonb),
    ('EU-HU', '["EU-AT","EU-HR","EU-RO","EU-RS","EU-SI","EU-SK","EU-UA"]'::jsonb, '["EU-BA","EU-CZ","EU-ME","EU-PL","EU-MK","EU-SM"]'::jsonb),
    ('EU-IE', '["EU-GB"]'::jsonb, '["EU-BE","EU-NL","EU-FR","EU-LU","EU-DK","EU-DE"]'::jsonb),
    ('EU-IS', '["EU-NONE"]'::jsonb, '["EU-IE","EU-NO","EU-GB","EU-SE","EU-DK","EU-NL"]'::jsonb),
    ('EU-IT', '["EU-AT","EU-CH","EU-FR","EU-SI","EU-SM","EU-VA"]'::jsonb, '["EU-LI","EU-MC","EU-HR","EU-BA","EU-CZ","EU-LU"]'::jsonb),
    ('EU-LI', '["EU-AT","EU-CH"]'::jsonb, '["EU-IT","EU-LU","EU-MC","EU-SM","EU-SI","EU-DE"]'::jsonb),
    ('EU-LT', '["EU-BY","EU-LV","EU-PL"]'::jsonb, '["EU-EE","EU-SK","EU-UA","EU-CZ","EU-MD","EU-FI"]'::jsonb),
    ('EU-LU', '["EU-BE","EU-DE","EU-FR"]'::jsonb, '["EU-NL","EU-CH","EU-LI","EU-AT","EU-CZ","EU-IT"]'::jsonb),
    ('EU-LV', '["EU-BY","EU-EE","EU-LT"]'::jsonb, '["EU-PL","EU-FI","EU-UA","EU-DK","EU-NO","EU-SK"]'::jsonb),
    ('EU-MC', '["EU-FR"]'::jsonb, '["EU-IT","EU-CH","EU-SM","EU-LI","EU-VA","EU-AD"]'::jsonb),
    ('EU-MD', '["EU-RO","EU-UA"]'::jsonb, '["EU-BG","EU-HU","EU-RS","EU-BY","EU-SK","EU-PL"]'::jsonb),
    ('EU-ME', '["EU-AL","EU-BA","EU-HR","EU-RS"]'::jsonb, '["EU-MK","EU-GR","EU-HU","EU-BG","EU-SI","EU-SM"]'::jsonb),
    ('EU-MK', '["EU-AL","EU-BG","EU-GR","EU-RS"]'::jsonb, '["EU-ME","EU-BA","EU-RO","EU-HR","EU-HU","EU-SI"]'::jsonb),
    ('EU-MT', '["EU-NONE"]'::jsonb, '["EU-VA","EU-AL","EU-GR","EU-ME","EU-MK","EU-SM"]'::jsonb),
    ('EU-NL', '["EU-BE","EU-DE"]'::jsonb, '["EU-LU","EU-DK","EU-GB","EU-CH","EU-LI","EU-FR"]'::jsonb),
    ('EU-NO', '["EU-FI","EU-SE"]'::jsonb, '["EU-DK","EU-EE","EU-LV","EU-NL","EU-GB","EU-LT"]'::jsonb),
    ('EU-PL', '["EU-BY","EU-CZ","EU-DE","EU-LT","EU-SK","EU-UA"]'::jsonb, '["EU-HU","EU-AT","EU-LV","EU-HR","EU-SI","EU-RO"]'::jsonb),
    ('EU-PT', '["EU-ES"]'::jsonb, '["EU-AD","EU-FR","EU-MC","EU-IE","EU-CH","EU-LU"]'::jsonb),
    ('EU-RO', '["EU-BG","EU-HU","EU-MD","EU-RS","EU-UA"]'::jsonb, '["EU-MK","EU-SK","EU-ME","EU-BA","EU-HR","EU-AL"]'::jsonb),
    ('EU-RS', '["EU-BA","EU-BG","EU-HR","EU-HU","EU-ME","EU-MK","EU-RO"]'::jsonb, '["EU-AL","EU-SI","EU-SK","EU-GR","EU-AT","EU-SM"]'::jsonb),
    ('EU-SE', '["EU-FI","EU-NO"]'::jsonb, '["EU-EE","EU-LV","EU-DK","EU-LT","EU-BY","EU-PL"]'::jsonb),
    ('EU-SI', '["EU-AT","EU-HR","EU-HU","EU-IT"]'::jsonb, '["EU-SM","EU-BA","EU-LI","EU-CZ","EU-SK","EU-ME"]'::jsonb),
    ('EU-SK', '["EU-AT","EU-CZ","EU-HU","EU-PL","EU-UA"]'::jsonb, '["EU-HR","EU-SI","EU-BA","EU-RS","EU-RO","EU-ME"]'::jsonb),
    ('EU-SM', '["EU-IT"]'::jsonb, '["EU-VA","EU-SI","EU-HR","EU-MC","EU-LI","EU-AT"]'::jsonb),
    ('EU-UA', '["EU-BY","EU-HU","EU-MD","EU-PL","EU-RO","EU-SK"]'::jsonb, '["EU-LT","EU-LV","EU-BG","EU-RS","EU-EE","EU-CZ"]'::jsonb),
    ('EU-VA', '["EU-IT"]'::jsonb, '["EU-SM","EU-MC","EU-SI","EU-BA","EU-HR","EU-ME"]'::jsonb)
) as q("TargetItemID", "CorrectItemIDs", "DistractorItemIDs")
where c."CategoryCode" = 'EUROPE_COUNTRIES'
on conflict ("CategoryID", "TargetItemID") do update set
  "CorrectItemIDs" = excluded."CorrectItemIDs",
  "DistractorItemIDs" = excluded."DistractorItemIDs",
  "IsActive" = excluded."IsActive",
  "UpdatedAt" = now();

commit;

-- 執行結果應為：QuestionCount = 43、ActiveQuestionCount = 43。
select
  c."CategoryCode",
  c."CategoryNameZh",
  count(q."QuestionID") as "QuestionCount",
  count(q."QuestionID") filter (where q."IsActive") as "ActiveQuestionCount"
from public."TblP124Category" c
left join public."TblP124Question" q
  on q."CategoryID" = c."CategoryID"
where c."CategoryCode" = 'EUROPE_COUNTRIES'
group by c."CategoryCode", c."CategoryNameZh";
