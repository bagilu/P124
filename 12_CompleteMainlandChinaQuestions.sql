-- P124 題庫增量：完成大陸區域 31 個省級行政區題目。
-- 適用於已建立 CN_PROVINCES 分類的資料庫；可重複執行。
-- 本檔僅操作 P124 專屬資料表，不會影響其他專案。

begin;

do $$
begin
  if not exists (
    select 1
    from public."TblP124Category"
    where "CategoryCode" = 'CN_PROVINCES'
  ) then
    raise exception '找不到 P124 分類 CN_PROVINCES，請先執行 database/08_SeedData.sql。';
  end if;
end
$$;

-- 更新分類名稱，並補入海南題所需的「無陸地相鄰地區」選項。
update public."TblP124Category"
set
  "CategoryNameZh" = '大陸區域省級行政區',
  "CategoryNameEn" = 'Mainland China Provincial-level Divisions',
  "DescriptionZh" = '大陸區域31個省級行政區的陸地接壤關係',
  "DescriptionEn" = 'Land-border relationships among 31 provincial-level divisions in mainland China',
  "Items" = case
    when exists (
      select 1
      from jsonb_array_elements("Items") as item
      where item->>'id' = 'CN-NONE'
    ) then "Items"
    else "Items" || jsonb_build_array(
      jsonb_build_object(
        'id', 'CN-NONE',
        'zh', '無陸地相鄰地區',
        'en', 'No land-border neighbors'
      )
    )
  end,
  "UpdatedAt" = now()
where "CategoryCode" = 'CN_PROVINCES';

-- CorrectItemIDs：全部正確的省級陸地鄰區。
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
    ('CN-AH', '["CN-HA","CN-HB","CN-JS","CN-JX","CN-ZJ"]'::jsonb, '["CN-SH","CN-SD","CN-FJ","CN-HN","CN-SX"]'::jsonb),
    ('CN-BJ', '["CN-HE","CN-TJ"]'::jsonb, '["CN-SD","CN-SX","CN-LN","CN-NM","CN-HA"]'::jsonb),
    ('CN-CQ', '["CN-GZ","CN-HB","CN-HN","CN-SC"]'::jsonb, '["CN-SN","CN-HA","CN-GX","CN-NX","CN-JX"]'::jsonb),
    ('CN-FJ', '["CN-GD","CN-JX","CN-ZJ"]'::jsonb, '["CN-HN","CN-SH","CN-AH","CN-HB","CN-JS"]'::jsonb),
    ('CN-GD', '["CN-FJ","CN-GX","CN-HN","CN-JX"]'::jsonb, '["CN-HI","CN-GZ","CN-HB","CN-CQ","CN-ZJ"]'::jsonb),
    ('CN-GS', '["CN-NM","CN-NX","CN-QH","CN-SC","CN-SN","CN-XJ"]'::jsonb, '["CN-SX","CN-CQ","CN-HA","CN-HE","CN-HB"]'::jsonb),
    ('CN-GX', '["CN-GD","CN-GZ","CN-HN","CN-YN"]'::jsonb, '["CN-HI","CN-CQ","CN-JX","CN-HB","CN-FJ"]'::jsonb),
    ('CN-GZ', '["CN-CQ","CN-GX","CN-HN","CN-SC","CN-YN"]'::jsonb, '["CN-GD","CN-HB","CN-JX","CN-HI","CN-HA"]'::jsonb),
    ('CN-HA', '["CN-AH","CN-HB","CN-HE","CN-SD","CN-SN","CN-SX"]'::jsonb, '["CN-CQ","CN-JS","CN-TJ","CN-HN","CN-NX"]'::jsonb),
    ('CN-HB', '["CN-AH","CN-CQ","CN-HA","CN-HN","CN-JX","CN-SN"]'::jsonb, '["CN-JS","CN-ZJ","CN-SX","CN-SD","CN-FJ"]'::jsonb),
    ('CN-HE', '["CN-BJ","CN-HA","CN-LN","CN-NM","CN-SD","CN-SX","CN-TJ"]'::jsonb, '["CN-SN","CN-JS","CN-AH","CN-NX","CN-HB"]'::jsonb),
    ('CN-HI', '["CN-NONE"]'::jsonb, '["CN-GD","CN-GX","CN-GZ","CN-HN","CN-JX"]'::jsonb),
    ('CN-HL', '["CN-JL","CN-NM"]'::jsonb, '["CN-LN","CN-BJ","CN-TJ","CN-HE","CN-SD"]'::jsonb),
    ('CN-HN', '["CN-CQ","CN-GD","CN-GX","CN-GZ","CN-HB","CN-JX"]'::jsonb, '["CN-FJ","CN-HA","CN-AH","CN-ZJ","CN-SC"]'::jsonb),
    ('CN-JL', '["CN-HL","CN-LN","CN-NM"]'::jsonb, '["CN-TJ","CN-BJ","CN-HE","CN-SD","CN-JS"]'::jsonb),
    ('CN-JS', '["CN-AH","CN-SD","CN-SH","CN-ZJ"]'::jsonb, '["CN-HA","CN-HB","CN-TJ","CN-JX","CN-FJ"]'::jsonb),
    ('CN-JX', '["CN-AH","CN-FJ","CN-GD","CN-HB","CN-HN"]'::jsonb, '["CN-ZJ","CN-SH","CN-GX","CN-JS","CN-HA"]'::jsonb),
    ('CN-LN', '["CN-HE","CN-JL","CN-NM"]'::jsonb, '["CN-TJ","CN-BJ","CN-SD","CN-HL","CN-JS"]'::jsonb),
    ('CN-NM', '["CN-GS","CN-HE","CN-HL","CN-JL","CN-LN","CN-NX","CN-SN","CN-SX"]'::jsonb, '["CN-BJ","CN-TJ","CN-SD","CN-HA","CN-JS"]'::jsonb),
    ('CN-NX', '["CN-GS","CN-NM","CN-SN"]'::jsonb, '["CN-SX","CN-HA","CN-CQ","CN-SC","CN-HE"]'::jsonb),
    ('CN-QH', '["CN-GS","CN-SC","CN-XJ","CN-XZ"]'::jsonb, '["CN-NX","CN-SN","CN-YN","CN-CQ","CN-GZ"]'::jsonb),
    ('CN-SC', '["CN-CQ","CN-GS","CN-GZ","CN-QH","CN-SN","CN-XZ","CN-YN"]'::jsonb, '["CN-NX","CN-HN","CN-GX","CN-HB","CN-HA"]'::jsonb),
    ('CN-SD', '["CN-HA","CN-HE","CN-JS"]'::jsonb, '["CN-TJ","CN-BJ","CN-AH","CN-SX","CN-LN"]'::jsonb),
    ('CN-SH', '["CN-JS","CN-ZJ"]'::jsonb, '["CN-AH","CN-SD","CN-FJ","CN-JX","CN-HB"]'::jsonb),
    ('CN-SN', '["CN-GS","CN-HA","CN-HB","CN-NM","CN-NX","CN-SC","CN-SX"]'::jsonb, '["CN-CQ","CN-HE","CN-SD","CN-BJ","CN-TJ"]'::jsonb),
    ('CN-SX', '["CN-HA","CN-HE","CN-NM","CN-SN"]'::jsonb, '["CN-BJ","CN-TJ","CN-SD","CN-NX","CN-HB"]'::jsonb),
    ('CN-TJ', '["CN-BJ","CN-HE"]'::jsonb, '["CN-SD","CN-LN","CN-SX","CN-NM","CN-HA"]'::jsonb),
    ('CN-XJ', '["CN-GS","CN-QH","CN-XZ"]'::jsonb, '["CN-NX","CN-SC","CN-SN","CN-SX","CN-YN"]'::jsonb),
    ('CN-XZ', '["CN-QH","CN-SC","CN-XJ","CN-YN"]'::jsonb, '["CN-GS","CN-NX","CN-GZ","CN-CQ","CN-SN"]'::jsonb),
    ('CN-YN', '["CN-GX","CN-GZ","CN-SC","CN-XZ"]'::jsonb, '["CN-CQ","CN-HN","CN-HI","CN-GD","CN-QH"]'::jsonb),
    ('CN-ZJ', '["CN-AH","CN-FJ","CN-JS","CN-SH"]'::jsonb, '["CN-JX","CN-HB","CN-SD","CN-HA","CN-HN"]'::jsonb)
) as q("TargetItemID", "CorrectItemIDs", "DistractorItemIDs")
where c."CategoryCode" = 'CN_PROVINCES'
on conflict ("CategoryID", "TargetItemID") do update set
  "CorrectItemIDs" = excluded."CorrectItemIDs",
  "DistractorItemIDs" = excluded."DistractorItemIDs",
  "IsActive" = excluded."IsActive",
  "UpdatedAt" = now();

commit;

-- 執行結果應為：QuestionCount = 31、ActiveQuestionCount = 31。
select
  c."CategoryCode",
  c."CategoryNameZh",
  count(q."QuestionID") as "QuestionCount",
  count(q."QuestionID") filter (where q."IsActive") as "ActiveQuestionCount"
from public."TblP124Category" c
left join public."TblP124Question" q
  on q."CategoryID" = c."CategoryID"
where c."CategoryCode" = 'CN_PROVINCES'
group by c."CategoryCode", c."CategoryNameZh";
