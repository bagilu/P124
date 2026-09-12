-- P124 V0.7 題庫增量：新增北美洲、中美洲與加勒比海 23 個主權國家。
-- 可重複執行；既有資料會更新，不會建立重複分類或重複題目。
-- 僅計本分類國家之間的陸地邊界；巴拿馬與哥倫比亞的跨分類邊界不列入答案。
-- 本檔僅操作 P124 專屬資料表，不會影響其他專案。

begin;

insert into public."TblP124Category" (
  "CategoryCode", "CategoryNameZh", "CategoryNameEn",
  "DescriptionZh", "DescriptionEn", "Items", "SortOrder", "IsActive"
) values (
  'NORTH_CENTRAL_CARIBBEAN_COUNTRIES',
  '北美洲、中美洲與加勒比海國家',
  'North, Central American & Caribbean Countries',
  '北美洲、中美洲與加勒比海23個主權國家之間的陸地接壤關係',
  'Land-border relationships among 23 sovereign countries in North America, Central America and the Caribbean',
  $$[
    {"id":"NA-AG","zh":"安地卡及巴布達","en":"Antigua and Barbuda"},
    {"id":"NA-BB","zh":"巴貝多","en":"Barbados"},
    {"id":"NA-BS","zh":"巴哈馬","en":"Bahamas"},
    {"id":"NA-BZ","zh":"貝里斯","en":"Belize"},
    {"id":"NA-CA","zh":"加拿大","en":"Canada"},
    {"id":"NA-CR","zh":"哥斯大黎加","en":"Costa Rica"},
    {"id":"NA-CU","zh":"古巴","en":"Cuba"},
    {"id":"NA-DM","zh":"多米尼克","en":"Dominica"},
    {"id":"NA-DO","zh":"多明尼加","en":"Dominican Republic"},
    {"id":"NA-GD","zh":"格瑞那達","en":"Grenada"},
    {"id":"NA-GT","zh":"瓜地馬拉","en":"Guatemala"},
    {"id":"NA-HN","zh":"宏都拉斯","en":"Honduras"},
    {"id":"NA-HT","zh":"海地","en":"Haiti"},
    {"id":"NA-JM","zh":"牙買加","en":"Jamaica"},
    {"id":"NA-KN","zh":"聖克里斯多福及尼維斯","en":"Saint Kitts and Nevis"},
    {"id":"NA-LC","zh":"聖露西亞","en":"Saint Lucia"},
    {"id":"NA-MX","zh":"墨西哥","en":"Mexico"},
    {"id":"NA-NI","zh":"尼加拉瓜","en":"Nicaragua"},
    {"id":"NA-PA","zh":"巴拿馬","en":"Panama"},
    {"id":"NA-SV","zh":"薩爾瓦多","en":"El Salvador"},
    {"id":"NA-TT","zh":"千里達及托巴哥","en":"Trinidad and Tobago"},
    {"id":"NA-US","zh":"美國","en":"United States"},
    {"id":"NA-VC","zh":"聖文森及格瑞那丁","en":"Saint Vincent and the Grenadines"},
    {"id":"NA-NONE","zh":"無陸地相鄰國家","en":"No land-border neighbors"}
  ]$$::jsonb,
  60,
  true
)
on conflict ("CategoryCode") do update set
  "CategoryNameZh" = excluded."CategoryNameZh",
  "CategoryNameEn" = excluded."CategoryNameEn",
  "DescriptionZh" = excluded."DescriptionZh",
  "DescriptionEn" = excluded."DescriptionEn",
  "Items" = excluded."Items",
  "SortOrder" = excluded."SortOrder",
  "IsActive" = excluded."IsActive",
  "UpdatedAt" = now();

-- 分類順序：台灣、亞洲、非洲、歐洲、南美洲、北中美洲與加勒比海、大陸、美國。
update public."TblP124Category" as c
set "SortOrder" = ordering."SortOrder", "UpdatedAt" = now()
from (
  values
    ('TW_COUNTIES', 10),
    ('ASIA_COUNTRIES', 20),
    ('AFRICA_COUNTRIES', 30),
    ('EUROPE_COUNTRIES', 40),
    ('SOUTH_AMERICA_COUNTRIES', 50),
    ('NORTH_CENTRAL_CARIBBEAN_COUNTRIES', 60),
    ('CN_PROVINCES', 70),
    ('US_STATES', 80)
) as ordering("CategoryCode", "SortOrder")
where c."CategoryCode" = ordering."CategoryCode";

insert into public."TblP124Question" (
  "CategoryID", "TargetItemID", "CorrectItemIDs", "DistractorItemIDs", "IsActive"
)
select c."CategoryID", q."TargetItemID", q."CorrectItemIDs", q."DistractorItemIDs", true
from public."TblP124Category" c
cross join (
  values
    ('NA-AG', '["NA-NONE"]'::jsonb, '["NA-KN","NA-DM","NA-LC","NA-VC","NA-BB","NA-GD"]'::jsonb),
    ('NA-BB', '["NA-NONE"]'::jsonb, '["NA-LC","NA-VC","NA-GD","NA-DM","NA-TT","NA-AG"]'::jsonb),
    ('NA-BS', '["NA-NONE"]'::jsonb, '["NA-CU","NA-US","NA-HT","NA-DO","NA-JM","NA-MX"]'::jsonb),
    ('NA-BZ', '["NA-GT","NA-MX"]'::jsonb, '["NA-HN","NA-SV","NA-NI","NA-CR","NA-CU","NA-JM"]'::jsonb),
    ('NA-CA', '["NA-US"]'::jsonb, '["NA-MX","NA-BS","NA-CU","NA-BZ","NA-GT","NA-HT"]'::jsonb),
    ('NA-CR', '["NA-NI","NA-PA"]'::jsonb, '["NA-HN","NA-SV","NA-GT","NA-BZ","NA-MX","NA-CU"]'::jsonb),
    ('NA-CU', '["NA-NONE"]'::jsonb, '["NA-BS","NA-HT","NA-JM","NA-US","NA-MX","NA-DO"]'::jsonb),
    ('NA-DM', '["NA-NONE"]'::jsonb, '["NA-AG","NA-LC","NA-VC","NA-BB","NA-GD","NA-KN"]'::jsonb),
    ('NA-DO', '["NA-HT"]'::jsonb, '["NA-CU","NA-JM","NA-BS","NA-DM","NA-AG","NA-TT"]'::jsonb),
    ('NA-GD', '["NA-NONE"]'::jsonb, '["NA-TT","NA-VC","NA-LC","NA-BB","NA-DM","NA-AG"]'::jsonb),
    ('NA-GT', '["NA-BZ","NA-HN","NA-MX","NA-SV"]'::jsonb, '["NA-NI","NA-CR","NA-PA","NA-CU","NA-JM","NA-HT"]'::jsonb),
    ('NA-HN', '["NA-GT","NA-NI","NA-SV"]'::jsonb, '["NA-BZ","NA-MX","NA-CR","NA-PA","NA-CU","NA-JM"]'::jsonb),
    ('NA-HT', '["NA-DO"]'::jsonb, '["NA-CU","NA-JM","NA-BS","NA-TT","NA-DM","NA-PA"]'::jsonb),
    ('NA-JM', '["NA-NONE"]'::jsonb, '["NA-CU","NA-HT","NA-DO","NA-BS","NA-MX","NA-PA"]'::jsonb),
    ('NA-KN', '["NA-NONE"]'::jsonb, '["NA-AG","NA-DM","NA-LC","NA-VC","NA-BS","NA-BB"]'::jsonb),
    ('NA-LC', '["NA-NONE"]'::jsonb, '["NA-DM","NA-VC","NA-BB","NA-GD","NA-AG","NA-TT"]'::jsonb),
    ('NA-MX', '["NA-BZ","NA-GT","NA-US"]'::jsonb, '["NA-CA","NA-CR","NA-HN","NA-SV","NA-NI","NA-PA"]'::jsonb),
    ('NA-NI', '["NA-CR","NA-HN"]'::jsonb, '["NA-GT","NA-SV","NA-BZ","NA-PA","NA-MX","NA-CU"]'::jsonb),
    ('NA-PA', '["NA-CR"]'::jsonb, '["NA-NI","NA-HN","NA-SV","NA-GT","NA-MX","NA-CU"]'::jsonb),
    ('NA-SV', '["NA-GT","NA-HN"]'::jsonb, '["NA-BZ","NA-MX","NA-NI","NA-CR","NA-PA","NA-CU"]'::jsonb),
    ('NA-TT', '["NA-NONE"]'::jsonb, '["NA-GD","NA-VC","NA-BB","NA-LC","NA-DM","NA-AG"]'::jsonb),
    ('NA-US', '["NA-CA","NA-MX"]'::jsonb, '["NA-BZ","NA-GT","NA-BS","NA-CU","NA-JM","NA-PA"]'::jsonb),
    ('NA-VC', '["NA-NONE"]'::jsonb, '["NA-LC","NA-GD","NA-BB","NA-TT","NA-DM","NA-AG"]'::jsonb)
) as q("TargetItemID", "CorrectItemIDs", "DistractorItemIDs")
where c."CategoryCode" = 'NORTH_CENTRAL_CARIBBEAN_COUNTRIES'
on conflict ("CategoryID", "TargetItemID") do update set
  "CorrectItemIDs" = excluded."CorrectItemIDs",
  "DistractorItemIDs" = excluded."DistractorItemIDs",
  "IsActive" = excluded."IsActive",
  "UpdatedAt" = now();

commit;

-- 第一段結果應為：QuestionCount = 23、ActiveQuestionCount = 23。
select
  c."CategoryCode", c."CategoryNameZh",
  count(q."QuestionID") as "QuestionCount",
  count(q."QuestionID") filter (where q."IsActive") as "ActiveQuestionCount"
from public."TblP124Category" c
left join public."TblP124Question" q on q."CategoryID" = c."CategoryID"
where c."CategoryCode" = 'NORTH_CENTRAL_CARIBBEAN_COUNTRIES'
group by c."CategoryCode", c."CategoryNameZh";

-- 第二段結果應依序顯示八個分類，SortOrder 為 10、20……80。
select "CategoryCode", "CategoryNameZh", "CategoryNameEn", "SortOrder"
from public."TblP124Category"
where "CategoryCode" in (
  'TW_COUNTIES', 'ASIA_COUNTRIES', 'AFRICA_COUNTRIES', 'EUROPE_COUNTRIES',
  'SOUTH_AMERICA_COUNTRIES', 'NORTH_CENTRAL_CARIBBEAN_COUNTRIES',
  'CN_PROVINCES', 'US_STATES'
)
order by "SortOrder", "CategoryID";
