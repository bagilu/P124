-- P124 題庫增量：完成亞洲 49 個國家與地區的題目。
-- 適用於已建立 ASIA_COUNTRIES 分類的資料庫；可重複執行。
-- 答案限於本分類的候選項目；俄羅斯、埃及、巴布亞紐幾內亞等分類外鄰國不列入。
-- 本檔僅操作 P124 專屬資料表，不會影響其他專案。

begin;

do $$
begin
  if not exists (
    select 1
    from public."TblP124Category"
    where "CategoryCode" = 'ASIA_COUNTRIES'
  ) then
    raise exception '找不到 P124 分類 ASIA_COUNTRIES，請先執行 database/11_AddAfricaAsiaSouthAmericaSamples.sql。';
  end if;
end
$$;

-- 確保島國及分類內無陸地鄰國者可使用專用答案。
update public."TblP124Category"
set
  "DescriptionZh" = '亞洲49個國家與地區之間的陸地接壤關係',
  "DescriptionEn" = 'Land-border relationships among 49 Asian countries and regions',
  "Items" = case
    when exists (
      select 1
      from jsonb_array_elements("Items") as item
      where item->>'id' = 'AS-NONE'
    ) then "Items"
    else "Items" || jsonb_build_array(
      jsonb_build_object(
        'id', 'AS-NONE',
        'zh', '無陸地相鄰國家',
        'en', 'No land-border neighbors'
      )
    )
  end,
  "UpdatedAt" = now()
where "CategoryCode" = 'ASIA_COUNTRIES';

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
    ('AS-AE', '["AS-OM","AS-SA"]'::jsonb, '["AS-QA","AS-BH","AS-IR","AS-KW","AS-YE","AS-IQ"]'::jsonb),
    ('AS-AF', '["AS-CN","AS-IR","AS-PK","AS-TJ","AS-TM","AS-UZ"]'::jsonb, '["AS-KG","AS-OM","AS-AE","AS-KZ","AS-NP","AS-BH"]'::jsonb),
    ('AS-AM', '["AS-AZ","AS-GE","AS-IR","AS-TR"]'::jsonb, '["AS-IQ","AS-SY","AS-LB","AS-TM","AS-CY","AS-KW"]'::jsonb),
    ('AS-AZ', '["AS-AM","AS-GE","AS-IR","AS-TR"]'::jsonb, '["AS-IQ","AS-TM","AS-SY","AS-LB","AS-KW","AS-CY"]'::jsonb),
    ('AS-BD', '["AS-IN","AS-MM"]'::jsonb, '["AS-BT","AS-NP","AS-LA","AS-TH","AS-VN","AS-CN"]'::jsonb),
    ('AS-BH', '["AS-NONE"]'::jsonb, '["AS-QA","AS-KW","AS-AE","AS-SA","AS-IR","AS-OM"]'::jsonb),
    ('AS-BN', '["AS-MY"]'::jsonb, '["AS-PH","AS-SG","AS-KH","AS-ID","AS-TH","AS-TL"]'::jsonb),
    ('AS-BT', '["AS-CN","AS-IN"]'::jsonb, '["AS-BD","AS-NP","AS-MM","AS-LA","AS-VN","AS-TH"]'::jsonb),
    ('AS-CN', '["AS-AF","AS-BT","AS-IN","AS-KG","AS-KP","AS-KZ","AS-LA","AS-MM","AS-MN","AS-NP","AS-PK","AS-TJ","AS-VN"]'::jsonb, '["AS-TW","AS-BD","AS-TH","AS-KR","AS-KH","AS-PH"]'::jsonb),
    ('AS-CY', '["AS-NONE"]'::jsonb, '["AS-LB","AS-PS","AS-SY","AS-IL","AS-TR","AS-JO"]'::jsonb),
    ('AS-GE', '["AS-AM","AS-AZ","AS-TR"]'::jsonb, '["AS-SY","AS-IQ","AS-LB","AS-CY","AS-TM","AS-PS"]'::jsonb),
    ('AS-ID', '["AS-MY","AS-TL"]'::jsonb, '["AS-SG","AS-BN","AS-KH","AS-TH","AS-LA","AS-LK"]'::jsonb),
    ('AS-IL', '["AS-JO","AS-LB","AS-PS","AS-SY"]'::jsonb, '["AS-CY","AS-IQ","AS-TR","AS-KW","AS-SA","AS-AM"]'::jsonb),
    ('AS-IN', '["AS-BD","AS-BT","AS-CN","AS-MM","AS-NP","AS-PK"]'::jsonb, '["AS-LK","AS-AF","AS-TJ","AS-MV","AS-KG","AS-OM"]'::jsonb),
    ('AS-IQ', '["AS-IR","AS-JO","AS-KW","AS-SA","AS-SY","AS-TR"]'::jsonb, '["AS-LB","AS-PS","AS-IL","AS-AM","AS-AZ","AS-CY"]'::jsonb),
    ('AS-IR', '["AS-AF","AS-AM","AS-AZ","AS-IQ","AS-PK","AS-TM","AS-TR"]'::jsonb, '["AS-KW","AS-BH","AS-QA","AS-AE","AS-OM","AS-UZ"]'::jsonb),
    ('AS-JO', '["AS-IL","AS-IQ","AS-PS","AS-SA","AS-SY"]'::jsonb, '["AS-LB","AS-CY","AS-TR","AS-KW","AS-AM","AS-GE"]'::jsonb),
    ('AS-JP', '["AS-NONE"]'::jsonb, '["AS-KR","AS-KP","AS-TW","AS-CN","AS-MN","AS-PH"]'::jsonb),
    ('AS-KG', '["AS-CN","AS-KZ","AS-TJ","AS-UZ"]'::jsonb, '["AS-AF","AS-TM","AS-PK","AS-NP","AS-IR","AS-BT"]'::jsonb),
    ('AS-KH', '["AS-LA","AS-TH","AS-VN"]'::jsonb, '["AS-SG","AS-MM","AS-BN","AS-MY","AS-ID","AS-PH"]'::jsonb),
    ('AS-KP', '["AS-CN","AS-KR"]'::jsonb, '["AS-JP","AS-TW","AS-MN","AS-VN","AS-PH","AS-LA"]'::jsonb),
    ('AS-KR', '["AS-KP"]'::jsonb, '["AS-JP","AS-TW","AS-CN","AS-MN","AS-VN","AS-PH"]'::jsonb),
    ('AS-KW', '["AS-IQ","AS-SA"]'::jsonb, '["AS-BH","AS-QA","AS-IR","AS-AE","AS-SY","AS-JO"]'::jsonb),
    ('AS-KZ', '["AS-CN","AS-KG","AS-TM","AS-UZ"]'::jsonb, '["AS-TJ","AS-AF","AS-AZ","AS-GE","AS-AM","AS-PK"]'::jsonb),
    ('AS-LA', '["AS-CN","AS-KH","AS-MM","AS-TH","AS-VN"]'::jsonb, '["AS-BD","AS-BT","AS-TW","AS-SG","AS-BN","AS-NP"]'::jsonb),
    ('AS-LB', '["AS-IL","AS-SY"]'::jsonb, '["AS-PS","AS-CY","AS-JO","AS-TR","AS-IQ","AS-AM"]'::jsonb),
    ('AS-LK', '["AS-NONE"]'::jsonb, '["AS-MV","AS-IN","AS-BD","AS-MM","AS-NP","AS-TH"]'::jsonb),
    ('AS-MM', '["AS-BD","AS-CN","AS-IN","AS-LA","AS-TH"]'::jsonb, '["AS-BT","AS-VN","AS-KH","AS-NP","AS-LK","AS-SG"]'::jsonb),
    ('AS-MN', '["AS-CN"]'::jsonb, '["AS-KP","AS-KR","AS-BT","AS-KG","AS-NP","AS-KZ"]'::jsonb),
    ('AS-MV', '["AS-NONE"]'::jsonb, '["AS-LK","AS-IN","AS-OM","AS-BD","AS-PK","AS-NP"]'::jsonb),
    ('AS-MY', '["AS-BN","AS-ID","AS-TH"]'::jsonb, '["AS-SG","AS-PH","AS-KH","AS-TL","AS-LA","AS-VN"]'::jsonb),
    ('AS-NP', '["AS-CN","AS-IN"]'::jsonb, '["AS-BT","AS-BD","AS-MM","AS-PK","AS-TJ","AS-KG"]'::jsonb),
    ('AS-OM', '["AS-AE","AS-SA","AS-YE"]'::jsonb, '["AS-QA","AS-BH","AS-IR","AS-KW","AS-PK","AS-AF"]'::jsonb),
    ('AS-PH', '["AS-NONE"]'::jsonb, '["AS-BN","AS-MY","AS-TW","AS-KH","AS-VN","AS-TL"]'::jsonb),
    ('AS-PK', '["AS-AF","AS-CN","AS-IN","AS-IR"]'::jsonb, '["AS-TJ","AS-OM","AS-UZ","AS-NP","AS-KG","AS-TM"]'::jsonb),
    ('AS-PS', '["AS-IL","AS-JO"]'::jsonb, '["AS-LB","AS-CY","AS-SY","AS-IQ","AS-TR","AS-KW"]'::jsonb),
    ('AS-QA', '["AS-SA"]'::jsonb, '["AS-BH","AS-AE","AS-KW","AS-OM","AS-IR","AS-IQ"]'::jsonb),
    ('AS-SA', '["AS-AE","AS-IQ","AS-JO","AS-KW","AS-OM","AS-QA","AS-YE"]'::jsonb, '["AS-BH","AS-IL","AS-PS","AS-IR","AS-SY","AS-LB"]'::jsonb),
    ('AS-SG', '["AS-NONE"]'::jsonb, '["AS-ID","AS-MY","AS-BN","AS-KH","AS-TH","AS-LA"]'::jsonb),
    ('AS-SY', '["AS-IL","AS-IQ","AS-JO","AS-LB","AS-TR"]'::jsonb, '["AS-PS","AS-CY","AS-AM","AS-GE","AS-AZ","AS-KW"]'::jsonb),
    ('AS-TH', '["AS-KH","AS-LA","AS-MM","AS-MY"]'::jsonb, '["AS-VN","AS-BD","AS-SG","AS-BT","AS-ID","AS-BN"]'::jsonb),
    ('AS-TJ', '["AS-AF","AS-CN","AS-KG","AS-UZ"]'::jsonb, '["AS-PK","AS-TM","AS-KZ","AS-NP","AS-IR","AS-IN"]'::jsonb),
    ('AS-TL', '["AS-ID"]'::jsonb, '["AS-MY","AS-BN","AS-PH","AS-SG","AS-KH","AS-TW"]'::jsonb),
    ('AS-TM', '["AS-AF","AS-IR","AS-KZ","AS-UZ"]'::jsonb, '["AS-AZ","AS-AM","AS-TJ","AS-GE","AS-KG","AS-PK"]'::jsonb),
    ('AS-TR', '["AS-AM","AS-AZ","AS-GE","AS-IQ","AS-IR","AS-SY"]'::jsonb, '["AS-CY","AS-LB","AS-PS","AS-IL","AS-JO","AS-KW"]'::jsonb),
    ('AS-TW', '["AS-NONE"]'::jsonb, '["AS-PH","AS-KR","AS-VN","AS-CN","AS-KP","AS-LA"]'::jsonb),
    ('AS-UZ', '["AS-AF","AS-KG","AS-KZ","AS-TJ","AS-TM"]'::jsonb, '["AS-IR","AS-AZ","AS-PK","AS-AM","AS-GE","AS-KW"]'::jsonb),
    ('AS-VN', '["AS-CN","AS-KH","AS-LA"]'::jsonb, '["AS-TH","AS-MM","AS-TW","AS-BD","AS-BT","AS-BN"]'::jsonb),
    ('AS-YE', '["AS-OM","AS-SA"]'::jsonb, '["AS-QA","AS-AE","AS-BH","AS-KW","AS-JO","AS-IQ"]'::jsonb)
) as q("TargetItemID", "CorrectItemIDs", "DistractorItemIDs")
where c."CategoryCode" = 'ASIA_COUNTRIES'
on conflict ("CategoryID", "TargetItemID") do update set
  "CorrectItemIDs" = excluded."CorrectItemIDs",
  "DistractorItemIDs" = excluded."DistractorItemIDs",
  "IsActive" = excluded."IsActive",
  "UpdatedAt" = now();

commit;

-- 執行結果應為：QuestionCount = 49、ActiveQuestionCount = 49。
select
  c."CategoryCode",
  c."CategoryNameZh",
  count(q."QuestionID") as "QuestionCount",
  count(q."QuestionID") filter (where q."IsActive") as "ActiveQuestionCount"
from public."TblP124Category" c
left join public."TblP124Question" q
  on q."CategoryID" = c."CategoryID"
where c."CategoryCode" = 'ASIA_COUNTRIES'
group by c."CategoryCode", c."CategoryNameZh";
