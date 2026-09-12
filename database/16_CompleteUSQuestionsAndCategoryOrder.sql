-- P124 題庫增量：完成美國 50 州題目，並調整全部分類顯示順序。
-- 適用於已建立 US_STATES 及其餘六個分類的資料庫；可重複執行。
-- 答案限於美國 50 州；加拿大、墨西哥與華盛頓特區不列入。
-- 僅在角點相遇或只有水域邊界的州，不視為陸地接壤。
-- 本檔僅操作 P124 專屬資料表，不會影響其他專案。

begin;

do $$
begin
  if not exists (
    select 1 from public."TblP124Category" where "CategoryCode" = 'US_STATES'
  ) then
    raise exception '找不到 P124 分類 US_STATES，請先執行 database/08_SeedData.sql。';
  end if;
end
$$;

-- 分類顯示順序：台灣、亞洲、非洲、歐洲、南美洲、大陸、美國。
update public."TblP124Category" as c
set "SortOrder" = ordering."SortOrder", "UpdatedAt" = now()
from (
  values
    ('TW_COUNTIES', 10),
    ('ASIA_COUNTRIES', 20),
    ('AFRICA_COUNTRIES', 30),
    ('EUROPE_COUNTRIES', 40),
    ('SOUTH_AMERICA_COUNTRIES', 50),
    ('CN_PROVINCES', 60),
    ('US_STATES', 70)
) as ordering("CategoryCode", "SortOrder")
where c."CategoryCode" = ordering."CategoryCode";

update public."TblP124Category"
set "CategoryNameZh" = '大陸區域省級行政區', "UpdatedAt" = now()
where "CategoryCode" = 'CN_PROVINCES';

-- 確保阿拉斯加州與夏威夷州可使用「無陸地相鄰州」答案。
update public."TblP124Category"
set
  "DescriptionZh" = '美國50州之間的陸地接壤關係',
  "DescriptionEn" = 'Land-border relationships among the 50 U.S. states',
  "Items" = case
    when exists (
      select 1 from jsonb_array_elements("Items") as item where item->>'id' = 'US-NONE'
    ) then "Items"
    else "Items" || jsonb_build_array(
      jsonb_build_object('id', 'US-NONE', 'zh', '無陸地相鄰州', 'en', 'No land-border neighbors')
    )
  end,
  "UpdatedAt" = now()
where "CategoryCode" = 'US_STATES';

-- CorrectItemIDs：美國50州範圍內全部正確的陸地鄰州。
-- DistractorItemIDs：地理位置較近、但不直接接壤的人工誘答。
insert into public."TblP124Question" (
  "CategoryID", "TargetItemID", "CorrectItemIDs", "DistractorItemIDs", "IsActive"
)
select c."CategoryID", q."TargetItemID", q."CorrectItemIDs", q."DistractorItemIDs", true
from public."TblP124Category" c
cross join (
  values
    ('US-AK', '["US-NONE"]'::jsonb, '["US-WA","US-OR","US-MT","US-ID","US-NV","US-ND"]'::jsonb),
    ('US-AL', '["US-FL","US-GA","US-MS","US-TN"]'::jsonb, '["US-KY","US-AR","US-LA","US-SC","US-IN","US-NC"]'::jsonb),
    ('US-AR', '["US-LA","US-MO","US-MS","US-OK","US-TN","US-TX"]'::jsonb, '["US-AL","US-IL","US-KY","US-KS","US-IN","US-IA"]'::jsonb),
    ('US-AZ', '["US-CA","US-NM","US-NV","US-UT"]'::jsonb, '["US-CO","US-WY","US-ID","US-TX","US-OR","US-KS"]'::jsonb),
    ('US-CA', '["US-AZ","US-NV","US-OR"]'::jsonb, '["US-UT","US-ID","US-WA","US-WY","US-NM","US-CO"]'::jsonb),
    ('US-CO', '["US-KS","US-NE","US-NM","US-OK","US-UT","US-WY"]'::jsonb, '["US-SD","US-AZ","US-ID","US-MT","US-NV","US-ND"]'::jsonb),
    ('US-CT', '["US-MA","US-NY","US-RI"]'::jsonb, '["US-NJ","US-NH","US-VT","US-DE","US-PA","US-MD"]'::jsonb),
    ('US-DE', '["US-MD","US-NJ","US-PA"]'::jsonb, '["US-VA","US-CT","US-RI","US-WV","US-NC","US-NY"]'::jsonb),
    ('US-FL', '["US-AL","US-GA"]'::jsonb, '["US-SC","US-NC","US-MS","US-TN","US-LA","US-KY"]'::jsonb),
    ('US-GA', '["US-AL","US-FL","US-NC","US-SC","US-TN"]'::jsonb, '["US-KY","US-MS","US-WV","US-VA","US-OH","US-IN"]'::jsonb),
    ('US-HI', '["US-NONE"]'::jsonb, '["US-CA","US-OR","US-NV","US-WA","US-AZ","US-ID"]'::jsonb),
    ('US-IA', '["US-IL","US-MN","US-MO","US-NE","US-SD","US-WI"]'::jsonb, '["US-KS","US-IN","US-MI","US-OK","US-ND","US-AR"]'::jsonb),
    ('US-ID', '["US-MT","US-NV","US-OR","US-UT","US-WA","US-WY"]'::jsonb, '["US-CO","US-CA","US-AZ","US-SD","US-ND","US-NE"]'::jsonb),
    ('US-IL', '["US-IA","US-IN","US-KY","US-MO","US-WI"]'::jsonb, '["US-MI","US-TN","US-OH","US-AR","US-WV","US-MN"]'::jsonb),
    ('US-IN', '["US-IL","US-KY","US-MI","US-OH"]'::jsonb, '["US-TN","US-WV","US-MO","US-WI","US-IA","US-VA"]'::jsonb),
    ('US-KS', '["US-CO","US-MO","US-NE","US-OK"]'::jsonb, '["US-IA","US-SD","US-AR","US-IL","US-NM","US-TX"]'::jsonb),
    ('US-KY', '["US-IL","US-IN","US-MO","US-OH","US-TN","US-VA","US-WV"]'::jsonb, '["US-AL","US-GA","US-SC","US-MS","US-NC","US-AR"]'::jsonb),
    ('US-LA', '["US-AR","US-MS","US-TX"]'::jsonb, '["US-AL","US-OK","US-TN","US-GA","US-MO","US-KY"]'::jsonb),
    ('US-MA', '["US-CT","US-NH","US-NY","US-RI","US-VT"]'::jsonb, '["US-NJ","US-ME","US-DE","US-PA","US-MD","US-VA"]'::jsonb),
    ('US-MD', '["US-DE","US-PA","US-VA","US-WV"]'::jsonb, '["US-NJ","US-CT","US-NY","US-NC","US-OH","US-RI"]'::jsonb),
    ('US-ME', '["US-NH"]'::jsonb, '["US-VT","US-MA","US-RI","US-CT","US-NY","US-NJ"]'::jsonb),
    ('US-MI', '["US-IN","US-OH","US-WI"]'::jsonb, '["US-IL","US-WV","US-PA","US-KY","US-IA","US-MN"]'::jsonb),
    ('US-MN', '["US-IA","US-ND","US-SD","US-WI"]'::jsonb, '["US-NE","US-MI","US-IL","US-MO","US-IN","US-KS"]'::jsonb),
    ('US-MO', '["US-AR","US-IA","US-IL","US-KS","US-KY","US-NE","US-OK","US-TN"]'::jsonb, '["US-IN","US-MS","US-WI","US-AL","US-MI","US-MN"]'::jsonb),
    ('US-MS', '["US-AL","US-AR","US-LA","US-TN"]'::jsonb, '["US-GA","US-KY","US-MO","US-OK","US-IL","US-IN"]'::jsonb),
    ('US-MT', '["US-ID","US-ND","US-SD","US-WY"]'::jsonb, '["US-WA","US-UT","US-OR","US-CO","US-NV","US-NE"]'::jsonb),
    ('US-NC', '["US-GA","US-SC","US-TN","US-VA"]'::jsonb, '["US-WV","US-MD","US-DE","US-PA","US-OH","US-NJ"]'::jsonb),
    ('US-ND', '["US-MN","US-MT","US-SD"]'::jsonb, '["US-NE","US-WY","US-IA","US-WI","US-KS","US-CO"]'::jsonb),
    ('US-NE', '["US-CO","US-IA","US-KS","US-MO","US-SD","US-WY"]'::jsonb, '["US-ND","US-OK","US-MN","US-WI","US-IL","US-NM"]'::jsonb),
    ('US-NH', '["US-MA","US-ME","US-VT"]'::jsonb, '["US-RI","US-CT","US-NY","US-NJ","US-PA","US-DE"]'::jsonb),
    ('US-NJ', '["US-DE","US-NY","US-PA"]'::jsonb, '["US-CT","US-MD","US-RI","US-MA","US-VA","US-NH"]'::jsonb),
    ('US-NM', '["US-AZ","US-CO","US-OK","US-TX"]'::jsonb, '["US-UT","US-KS","US-WY","US-NE","US-NV","US-SD"]'::jsonb),
    ('US-NV', '["US-AZ","US-CA","US-ID","US-OR","US-UT"]'::jsonb, '["US-WY","US-WA","US-CO","US-MT","US-NM","US-NE"]'::jsonb),
    ('US-NY', '["US-CT","US-MA","US-NJ","US-PA","US-VT"]'::jsonb, '["US-NH","US-RI","US-MD","US-DE","US-ME","US-VA"]'::jsonb),
    ('US-OH', '["US-IN","US-KY","US-MI","US-PA","US-WV"]'::jsonb, '["US-VA","US-MD","US-IL","US-TN","US-NC","US-DE"]'::jsonb),
    ('US-OK', '["US-AR","US-CO","US-KS","US-MO","US-NM","US-TX"]'::jsonb, '["US-NE","US-LA","US-MS","US-IA","US-IL","US-TN"]'::jsonb),
    ('US-OR', '["US-CA","US-ID","US-NV","US-WA"]'::jsonb, '["US-UT","US-MT","US-WY","US-AZ","US-CO","US-SD"]'::jsonb),
    ('US-PA', '["US-DE","US-MD","US-NJ","US-NY","US-OH","US-WV"]'::jsonb, '["US-VA","US-CT","US-MA","US-RI","US-VT","US-NH"]'::jsonb),
    ('US-RI', '["US-CT","US-MA"]'::jsonb, '["US-NH","US-VT","US-NJ","US-NY","US-ME","US-DE"]'::jsonb),
    ('US-SC', '["US-GA","US-NC"]'::jsonb, '["US-VA","US-WV","US-TN","US-AL","US-KY","US-FL"]'::jsonb),
    ('US-SD', '["US-IA","US-MN","US-MT","US-ND","US-NE","US-WY"]'::jsonb, '["US-KS","US-CO","US-WI","US-MO","US-OK","US-IL"]'::jsonb),
    ('US-TN', '["US-AL","US-AR","US-GA","US-KY","US-MO","US-MS","US-NC","US-VA"]'::jsonb, '["US-IN","US-IL","US-SC","US-OH","US-WV","US-LA"]'::jsonb),
    ('US-TX', '["US-AR","US-LA","US-NM","US-OK"]'::jsonb, '["US-KS","US-MS","US-MO","US-CO","US-AL","US-NE"]'::jsonb),
    ('US-UT', '["US-AZ","US-CO","US-ID","US-NV","US-WY"]'::jsonb, '["US-NM","US-CA","US-MT","US-OR","US-NE","US-SD"]'::jsonb),
    ('US-VA', '["US-KY","US-MD","US-NC","US-TN","US-WV"]'::jsonb, '["US-DE","US-PA","US-NJ","US-OH","US-SC","US-CT"]'::jsonb),
    ('US-VT', '["US-MA","US-NH","US-NY"]'::jsonb, '["US-CT","US-RI","US-ME","US-NJ","US-PA","US-DE"]'::jsonb),
    ('US-WA', '["US-ID","US-OR"]'::jsonb, '["US-MT","US-NV","US-WY","US-UT","US-CA","US-ND"]'::jsonb),
    ('US-WI', '["US-IA","US-IL","US-MI","US-MN"]'::jsonb, '["US-IN","US-MO","US-OH","US-KY","US-SD","US-NE"]'::jsonb),
    ('US-WV', '["US-KY","US-MD","US-OH","US-PA","US-VA"]'::jsonb, '["US-NC","US-DE","US-IN","US-SC","US-NJ","US-TN"]'::jsonb),
    ('US-WY', '["US-CO","US-ID","US-MT","US-NE","US-SD","US-UT"]'::jsonb, '["US-ND","US-NV","US-KS","US-NM","US-AZ","US-OR"]'::jsonb)
) as q("TargetItemID", "CorrectItemIDs", "DistractorItemIDs")
where c."CategoryCode" = 'US_STATES'
on conflict ("CategoryID", "TargetItemID") do update set
  "CorrectItemIDs" = excluded."CorrectItemIDs",
  "DistractorItemIDs" = excluded."DistractorItemIDs",
  "IsActive" = excluded."IsActive",
  "UpdatedAt" = now();

commit;

-- 第一段結果應為：QuestionCount = 50、ActiveQuestionCount = 50。
select
  c."CategoryCode", c."CategoryNameZh",
  count(q."QuestionID") as "QuestionCount",
  count(q."QuestionID") filter (where q."IsActive") as "ActiveQuestionCount"
from public."TblP124Category" c
left join public."TblP124Question" q on q."CategoryID" = c."CategoryID"
where c."CategoryCode" = 'US_STATES'
group by c."CategoryCode", c."CategoryNameZh";

-- 第二段結果應依序顯示七個分類，SortOrder 為 10、20……70。
select "CategoryCode", "CategoryNameZh", "CategoryNameEn", "SortOrder"
from public."TblP124Category"
where "CategoryCode" in (
  'TW_COUNTIES', 'ASIA_COUNTRIES', 'AFRICA_COUNTRIES', 'EUROPE_COUNTRIES',
  'SOUTH_AMERICA_COUNTRIES', 'CN_PROVINCES', 'US_STATES'
)
order by "SortOrder", "CategoryID";
