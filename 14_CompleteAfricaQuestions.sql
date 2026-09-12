-- P124 題庫增量：完成非洲 54 國題目。
-- 適用於已建立 AFRICA_COUNTRIES 分類的資料庫；可重複執行。
-- 答案限於本分類的 54 國候選項目；西撒哈拉等分類外區域不列入。
-- 本檔僅操作 P124 專屬資料表，不會影響其他專案。

begin;

do $$
begin
  if not exists (
    select 1
    from public."TblP124Category"
    where "CategoryCode" = 'AFRICA_COUNTRIES'
  ) then
    raise exception '找不到 P124 分類 AFRICA_COUNTRIES，請先執行 database/11_AddAfricaAsiaSouthAmericaSamples.sql。';
  end if;
end
$$;

-- 確保島國可使用「無陸地相鄰國家」答案。
update public."TblP124Category"
set
  "DescriptionZh" = '非洲54國之間的陸地接壤關係',
  "DescriptionEn" = 'Land-border relationships among 54 African countries',
  "Items" = case
    when exists (
      select 1
      from jsonb_array_elements("Items") as item
      where item->>'id' = 'AF-NONE'
    ) then "Items"
    else "Items" || jsonb_build_array(
      jsonb_build_object(
        'id', 'AF-NONE',
        'zh', '無陸地相鄰國家',
        'en', 'No land-border neighbors'
      )
    )
  end,
  "UpdatedAt" = now()
where "CategoryCode" = 'AFRICA_COUNTRIES';

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
    ('AF-AO', '["AF-CD","AF-CG","AF-NA","AF-ZM"]'::jsonb, '["AF-BW","AF-GA","AF-ZW","AF-BI","AF-MW","AF-GQ"]'::jsonb),
    ('AF-BF', '["AF-BJ","AF-CI","AF-GH","AF-ML","AF-NE","AF-TG"]'::jsonb, '["AF-GN","AF-NG","AF-LR","AF-MR","AF-SL","AF-GW"]'::jsonb),
    ('AF-BI', '["AF-CD","AF-RW","AF-TZ"]'::jsonb, '["AF-UG","AF-KE","AF-SS","AF-MW","AF-ZM","AF-MZ"]'::jsonb),
    ('AF-BJ', '["AF-BF","AF-NE","AF-NG","AF-TG"]'::jsonb, '["AF-GH","AF-CI","AF-ML","AF-ST","AF-CM","AF-GQ"]'::jsonb),
    ('AF-BW', '["AF-NA","AF-ZA","AF-ZM","AF-ZW"]'::jsonb, '["AF-SZ","AF-LS","AF-AO","AF-MW","AF-MZ","AF-TZ"]'::jsonb),
    ('AF-CD', '["AF-AO","AF-BI","AF-CF","AF-CG","AF-RW","AF-SS","AF-TZ","AF-UG","AF-ZM"]'::jsonb, '["AF-GA","AF-CM","AF-GQ","AF-KE","AF-MW","AF-ST"]'::jsonb),
    ('AF-CF', '["AF-CD","AF-CG","AF-CM","AF-SD","AF-SS","AF-TD"]'::jsonb, '["AF-GQ","AF-GA","AF-RW","AF-UG","AF-NG","AF-BI"]'::jsonb),
    ('AF-CG', '["AF-AO","AF-CD","AF-CF","AF-CM","AF-GA"]'::jsonb, '["AF-GQ","AF-ST","AF-NG","AF-RW","AF-BI","AF-TD"]'::jsonb),
    ('AF-CI', '["AF-BF","AF-GH","AF-GN","AF-LR","AF-ML"]'::jsonb, '["AF-SL","AF-TG","AF-BJ","AF-GW","AF-GM","AF-SN"]'::jsonb),
    ('AF-CM', '["AF-CF","AF-CG","AF-GA","AF-GQ","AF-NG","AF-TD"]'::jsonb, '["AF-ST","AF-BJ","AF-TG","AF-CD","AF-NE","AF-GH"]'::jsonb),
    ('AF-CV', '["AF-NONE"]'::jsonb, '["AF-GM","AF-SN","AF-GW","AF-SL","AF-GN","AF-MR"]'::jsonb),
    ('AF-DJ', '["AF-ER","AF-ET","AF-SO"]'::jsonb, '["AF-KE","AF-SS","AF-SD","AF-UG","AF-RW","AF-EG"]'::jsonb),
    ('AF-DZ', '["AF-LY","AF-MA","AF-ML","AF-MR","AF-NE","AF-TN"]'::jsonb, '["AF-BF","AF-BJ","AF-NG","AF-TG","AF-TD","AF-GH"]'::jsonb),
    ('AF-EG', '["AF-LY","AF-SD"]'::jsonb, '["AF-ER","AF-TD","AF-DJ","AF-SS","AF-TN","AF-ET"]'::jsonb),
    ('AF-ER', '["AF-DJ","AF-ET","AF-SD"]'::jsonb, '["AF-SS","AF-EG","AF-SO","AF-UG","AF-KE","AF-TD"]'::jsonb),
    ('AF-ET', '["AF-DJ","AF-ER","AF-KE","AF-SD","AF-SO","AF-SS"]'::jsonb, '["AF-UG","AF-RW","AF-BI","AF-TZ","AF-CF","AF-CD"]'::jsonb),
    ('AF-GA', '["AF-CG","AF-CM","AF-GQ"]'::jsonb, '["AF-ST","AF-NG","AF-CD","AF-CF","AF-AO","AF-TG"]'::jsonb),
    ('AF-GH', '["AF-BF","AF-CI","AF-TG"]'::jsonb, '["AF-BJ","AF-LR","AF-NG","AF-GN","AF-SL","AF-ST"]'::jsonb),
    ('AF-GM', '["AF-SN"]'::jsonb, '["AF-GW","AF-GN","AF-SL","AF-MR","AF-CV","AF-LR"]'::jsonb),
    ('AF-GN', '["AF-CI","AF-GW","AF-LR","AF-ML","AF-SL","AF-SN"]'::jsonb, '["AF-GM","AF-BF","AF-MR","AF-GH","AF-TG","AF-BJ"]'::jsonb),
    ('AF-GQ', '["AF-CM","AF-GA"]'::jsonb, '["AF-ST","AF-CG","AF-NG","AF-CF","AF-TG","AF-BJ"]'::jsonb),
    ('AF-GW', '["AF-GN","AF-SN"]'::jsonb, '["AF-GM","AF-SL","AF-LR","AF-MR","AF-CV","AF-CI"]'::jsonb),
    ('AF-KE', '["AF-ET","AF-SO","AF-SS","AF-TZ","AF-UG"]'::jsonb, '["AF-RW","AF-BI","AF-DJ","AF-KM","AF-MZ","AF-MW"]'::jsonb),
    ('AF-KM', '["AF-NONE"]'::jsonb, '["AF-MZ","AF-MG","AF-MW","AF-TZ","AF-KE","AF-SC"]'::jsonb),
    ('AF-LR', '["AF-CI","AF-GN","AF-SL"]'::jsonb, '["AF-GW","AF-GH","AF-GM","AF-BF","AF-SN","AF-TG"]'::jsonb),
    ('AF-LS', '["AF-ZA"]'::jsonb, '["AF-SZ","AF-BW","AF-ZW","AF-NA","AF-ZM","AF-MW"]'::jsonb),
    ('AF-LY', '["AF-DZ","AF-EG","AF-NE","AF-SD","AF-TD","AF-TN"]'::jsonb, '["AF-CF","AF-NG","AF-ML","AF-ER","AF-BJ","AF-MA"]'::jsonb),
    ('AF-MA', '["AF-DZ"]'::jsonb, '["AF-MR","AF-ML","AF-TN","AF-SN","AF-GM","AF-BF"]'::jsonb),
    ('AF-MG', '["AF-NONE"]'::jsonb, '["AF-KM","AF-MZ","AF-MU","AF-MW","AF-ZW","AF-SZ"]'::jsonb),
    ('AF-ML', '["AF-BF","AF-CI","AF-DZ","AF-GN","AF-MR","AF-NE","AF-SN"]'::jsonb, '["AF-BJ","AF-TG","AF-GH","AF-NG","AF-GM","AF-GW"]'::jsonb),
    ('AF-MR', '["AF-DZ","AF-ML","AF-SN"]'::jsonb, '["AF-GM","AF-GW","AF-GN","AF-BF","AF-SL","AF-MA"]'::jsonb),
    ('AF-MU', '["AF-NONE"]'::jsonb, '["AF-MG","AF-SC","AF-KM","AF-MZ","AF-MW","AF-SZ"]'::jsonb),
    ('AF-MW', '["AF-MZ","AF-TZ","AF-ZM"]'::jsonb, '["AF-ZW","AF-KM","AF-BI","AF-RW","AF-BW","AF-SZ"]'::jsonb),
    ('AF-MZ', '["AF-MW","AF-SZ","AF-TZ","AF-ZA","AF-ZM","AF-ZW"]'::jsonb, '["AF-KM","AF-MG","AF-BI","AF-RW","AF-KE","AF-BW"]'::jsonb),
    ('AF-NA', '["AF-AO","AF-BW","AF-ZA","AF-ZM"]'::jsonb, '["AF-ZW","AF-LS","AF-SZ","AF-MW","AF-CD","AF-CG"]'::jsonb),
    ('AF-NE', '["AF-BF","AF-BJ","AF-DZ","AF-LY","AF-ML","AF-NG","AF-TD"]'::jsonb, '["AF-TG","AF-CM","AF-GH","AF-CF","AF-GQ","AF-TN"]'::jsonb),
    ('AF-NG', '["AF-BJ","AF-CM","AF-NE","AF-TD"]'::jsonb, '["AF-TG","AF-GQ","AF-GH","AF-BF","AF-ST","AF-GA"]'::jsonb),
    ('AF-RW', '["AF-BI","AF-CD","AF-TZ","AF-UG"]'::jsonb, '["AF-KE","AF-SS","AF-MW","AF-CF","AF-ZM","AF-ET"]'::jsonb),
    ('AF-SC', '["AF-NONE"]'::jsonb, '["AF-SO","AF-KM","AF-MU","AF-MG","AF-KE","AF-MZ"]'::jsonb),
    ('AF-SD', '["AF-CF","AF-EG","AF-ER","AF-ET","AF-LY","AF-SS","AF-TD"]'::jsonb, '["AF-DJ","AF-UG","AF-KE","AF-RW","AF-NE","AF-CD"]'::jsonb),
    ('AF-SL', '["AF-GN","AF-LR"]'::jsonb, '["AF-GW","AF-GM","AF-CI","AF-SN","AF-GH","AF-BF"]'::jsonb),
    ('AF-SN', '["AF-GM","AF-GN","AF-GW","AF-ML","AF-MR"]'::jsonb, '["AF-SL","AF-CV","AF-LR","AF-CI","AF-BF","AF-GH"]'::jsonb),
    ('AF-SO', '["AF-DJ","AF-ET","AF-KE"]'::jsonb, '["AF-UG","AF-SC","AF-ER","AF-TZ","AF-SS","AF-KM"]'::jsonb),
    ('AF-SS', '["AF-CD","AF-CF","AF-ET","AF-KE","AF-SD","AF-UG"]'::jsonb, '["AF-RW","AF-BI","AF-ER","AF-DJ","AF-TD","AF-TZ"]'::jsonb),
    ('AF-ST', '["AF-NONE"]'::jsonb, '["AF-GQ","AF-GA","AF-CM","AF-CG","AF-NG","AF-TG"]'::jsonb),
    ('AF-SZ', '["AF-MZ","AF-ZA"]'::jsonb, '["AF-LS","AF-ZW","AF-BW","AF-ZM","AF-MW","AF-NA"]'::jsonb),
    ('AF-TD', '["AF-CF","AF-CM","AF-LY","AF-NE","AF-NG","AF-SD"]'::jsonb, '["AF-SS","AF-EG","AF-CG","AF-GQ","AF-BJ","AF-GA"]'::jsonb),
    ('AF-TG', '["AF-BF","AF-BJ","AF-GH"]'::jsonb, '["AF-NG","AF-CI","AF-ST","AF-ML","AF-LR","AF-GN"]'::jsonb),
    ('AF-TN', '["AF-DZ","AF-LY"]'::jsonb, '["AF-MA","AF-NE","AF-ML","AF-EG","AF-TD","AF-MR"]'::jsonb),
    ('AF-TZ', '["AF-BI","AF-CD","AF-KE","AF-MW","AF-MZ","AF-RW","AF-UG","AF-ZM"]'::jsonb, '["AF-KM","AF-ZW","AF-SO","AF-SS","AF-ET","AF-MG"]'::jsonb),
    ('AF-UG', '["AF-CD","AF-KE","AF-RW","AF-SS","AF-TZ"]'::jsonb, '["AF-BI","AF-ET","AF-SO","AF-CF","AF-DJ","AF-ER"]'::jsonb),
    ('AF-ZA', '["AF-BW","AF-LS","AF-MZ","AF-NA","AF-SZ","AF-ZW"]'::jsonb, '["AF-ZM","AF-AO","AF-MW","AF-MG","AF-KM","AF-TZ"]'::jsonb),
    ('AF-ZM', '["AF-AO","AF-BW","AF-CD","AF-MW","AF-MZ","AF-NA","AF-TZ","AF-ZW"]'::jsonb, '["AF-BI","AF-SZ","AF-RW","AF-LS","AF-ZA","AF-KM"]'::jsonb),
    ('AF-ZW', '["AF-BW","AF-MZ","AF-ZA","AF-ZM"]'::jsonb, '["AF-MW","AF-SZ","AF-LS","AF-NA","AF-AO","AF-TZ"]'::jsonb)
) as q("TargetItemID", "CorrectItemIDs", "DistractorItemIDs")
where c."CategoryCode" = 'AFRICA_COUNTRIES'
on conflict ("CategoryID", "TargetItemID") do update set
  "CorrectItemIDs" = excluded."CorrectItemIDs",
  "DistractorItemIDs" = excluded."DistractorItemIDs",
  "IsActive" = excluded."IsActive",
  "UpdatedAt" = now();

commit;

-- 執行結果應為：QuestionCount = 54、ActiveQuestionCount = 54。
select
  c."CategoryCode",
  c."CategoryNameZh",
  count(q."QuestionID") as "QuestionCount",
  count(q."QuestionID") filter (where q."IsActive") as "ActiveQuestionCount"
from public."TblP124Category" c
left join public."TblP124Question" q
  on q."CategoryID" = c."CategoryID"
where c."CategoryCode" = 'AFRICA_COUNTRIES'
group by c."CategoryCode", c."CategoryNameZh";
