-- P124 V0.3 增量更新：新增「台灣縣市」分類與三道示範題。
-- 已執行 V0.1 或 V0.2 SQL 的網站，只需執行本檔一次。

insert into public."TblP124Category" (
  "CategoryCode", "CategoryNameZh", "CategoryNameEn",
  "DescriptionZh", "DescriptionEn", "Items", "SortOrder", "IsActive"
) values (
  'TW_COUNTIES',
  '台灣縣市',
  'Taiwan Counties and Cities',
  '台灣22個縣市的陸地接壤關係',
  'Land-border relationships among Taiwan''s 22 counties and cities',
  $$[
    {"id":"TW-CHA","zh":"彰化縣","en":"Changhua County"},
    {"id":"TW-CYI","zh":"嘉義市","en":"Chiayi City"},
    {"id":"TW-CYQ","zh":"嘉義縣","en":"Chiayi County"},
    {"id":"TW-HSQ","zh":"新竹縣","en":"Hsinchu County"},
    {"id":"TW-HSZ","zh":"新竹市","en":"Hsinchu City"},
    {"id":"TW-HUA","zh":"花蓮縣","en":"Hualien County"},
    {"id":"TW-ILA","zh":"宜蘭縣","en":"Yilan County"},
    {"id":"TW-KEE","zh":"基隆市","en":"Keelung City"},
    {"id":"TW-KHH","zh":"高雄市","en":"Kaohsiung City"},
    {"id":"TW-KIN","zh":"金門縣","en":"Kinmen County"},
    {"id":"TW-LIE","zh":"連江縣","en":"Lienchiang County"},
    {"id":"TW-MIA","zh":"苗栗縣","en":"Miaoli County"},
    {"id":"TW-NAN","zh":"南投縣","en":"Nantou County"},
    {"id":"TW-NWT","zh":"新北市","en":"New Taipei City"},
    {"id":"TW-PEN","zh":"澎湖縣","en":"Penghu County"},
    {"id":"TW-PIF","zh":"屏東縣","en":"Pingtung County"},
    {"id":"TW-TXG","zh":"臺中市","en":"Taichung City"},
    {"id":"TW-TNN","zh":"臺南市","en":"Tainan City"},
    {"id":"TW-TPE","zh":"臺北市","en":"Taipei City"},
    {"id":"TW-TTT","zh":"臺東縣","en":"Taitung County"},
    {"id":"TW-TAO","zh":"桃園市","en":"Taoyuan City"},
    {"id":"TW-YUN","zh":"雲林縣","en":"Yunlin County"}
  ]$$::jsonb,
  40,
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

insert into public."TblP124Question" (
  "CategoryID", "TargetItemID", "CorrectItemIDs", "DistractorItemIDs", "IsActive"
)
select c."CategoryID", x."TargetItemID", x."CorrectItemIDs", x."DistractorItemIDs", true
from public."TblP124Category" c
join (
  values
    ('TW_COUNTIES', 'TW-HUA', '["TW-ILA","TW-TXG","TW-NAN","TW-KHH","TW-TTT"]'::jsonb, '["TW-TAO","TW-HSQ","TW-CYQ","TW-PIF"]'::jsonb),
    ('TW_COUNTIES', 'TW-CYQ', '["TW-YUN","TW-NAN","TW-KHH","TW-TNN","TW-CYI"]'::jsonb, '["TW-CHA","TW-TXG","TW-PIF","TW-TTT"]'::jsonb),
    ('TW_COUNTIES', 'TW-TPE', '["TW-NWT"]'::jsonb, '["TW-KEE","TW-TAO","TW-ILA"]'::jsonb)
) as x("CategoryCode", "TargetItemID", "CorrectItemIDs", "DistractorItemIDs")
  on c."CategoryCode" = x."CategoryCode"
on conflict ("CategoryID", "TargetItemID") do update set
  "CorrectItemIDs" = excluded."CorrectItemIDs",
  "DistractorItemIDs" = excluded."DistractorItemIDs",
  "IsActive" = excluded."IsActive",
  "UpdatedAt" = now();
