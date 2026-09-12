-- P124 V0.4 增量更新：完成台灣22縣市題庫。
-- 加入「無陸地相鄰縣市」答案，以支援金門、連江及澎湖三題。

update public."TblP124Category"
set "Items" = $$[
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
  {"id":"TW-YUN","zh":"雲林縣","en":"Yunlin County"},
  {"id":"TW-NONE","zh":"無陸地相鄰縣市","en":"No land-border neighbors"}
]$$::jsonb,
    "DescriptionZh" = '台灣22個縣市的陸地接壤關係（包含無陸地相鄰縣市）',
    "DescriptionEn" = 'Land-border relationships among Taiwan''s 22 counties and cities, including regions with no land-border neighbors',
    "UpdatedAt" = now()
where "CategoryCode" = 'TW_COUNTIES';

insert into public."TblP124Question" (
  "CategoryID", "TargetItemID", "CorrectItemIDs", "DistractorItemIDs", "IsActive"
)
select c."CategoryID", x."TargetItemID", x."CorrectItemIDs", x."DistractorItemIDs", true
from public."TblP124Category" c
join (
  values
    ('TW_COUNTIES','TW-CHA','["TW-NAN","TW-YUN","TW-TXG"]'::jsonb,'["TW-MIA","TW-CYQ","TW-TNN","TW-KHH"]'::jsonb),
    ('TW_COUNTIES','TW-CYI','["TW-CYQ"]'::jsonb,'["TW-YUN","TW-NAN","TW-TNN","TW-KHH"]'::jsonb),
    ('TW_COUNTIES','TW-CYQ','["TW-YUN","TW-NAN","TW-KHH","TW-TNN","TW-CYI"]'::jsonb,'["TW-CHA","TW-TXG","TW-PIF","TW-TTT"]'::jsonb),
    ('TW_COUNTIES','TW-HSQ','["TW-ILA","TW-TXG","TW-TAO","TW-MIA","TW-HSZ"]'::jsonb,'["TW-NWT","TW-KEE","TW-CHA","TW-HUA"]'::jsonb),
    ('TW_COUNTIES','TW-HSZ','["TW-MIA","TW-HSQ"]'::jsonb,'["TW-TAO","TW-TXG","TW-ILA","TW-NWT"]'::jsonb),
    ('TW_COUNTIES','TW-HUA','["TW-ILA","TW-TXG","TW-NAN","TW-KHH","TW-TTT"]'::jsonb,'["TW-TAO","TW-HSQ","TW-CYQ","TW-PIF"]'::jsonb),
    ('TW_COUNTIES','TW-ILA','["TW-NWT","TW-TXG","TW-TAO","TW-HUA","TW-HSQ"]'::jsonb,'["TW-TPE","TW-KEE","TW-MIA","TW-NAN"]'::jsonb),
    ('TW_COUNTIES','TW-KEE','["TW-NWT"]'::jsonb,'["TW-TPE","TW-TAO","TW-ILA","TW-HSQ"]'::jsonb),
    ('TW_COUNTIES','TW-KHH','["TW-NAN","TW-CYQ","TW-TNN","TW-TTT","TW-HUA","TW-PIF"]'::jsonb,'["TW-YUN","TW-CHA","TW-TXG","TW-PEN"]'::jsonb),
    ('TW_COUNTIES','TW-KIN','["TW-NONE"]'::jsonb,'["TW-PEN","TW-LIE","TW-CHA","TW-CYQ"]'::jsonb),
    ('TW_COUNTIES','TW-LIE','["TW-NONE"]'::jsonb,'["TW-KIN","TW-PEN","TW-KEE","TW-NWT"]'::jsonb),
    ('TW_COUNTIES','TW-MIA','["TW-TXG","TW-HSZ","TW-HSQ"]'::jsonb,'["TW-TAO","TW-CHA","TW-NAN","TW-NWT"]'::jsonb),
    ('TW_COUNTIES','TW-NAN','["TW-CHA","TW-YUN","TW-TXG","TW-CYQ","TW-KHH","TW-HUA"]'::jsonb,'["TW-MIA","TW-TNN","TW-TTT","TW-ILA"]'::jsonb),
    ('TW_COUNTIES','TW-NWT','["TW-ILA","TW-KEE","TW-TPE","TW-TAO"]'::jsonb,'["TW-HSQ","TW-HSZ","TW-MIA","TW-TXG"]'::jsonb),
    ('TW_COUNTIES','TW-PEN','["TW-NONE"]'::jsonb,'["TW-CYQ","TW-YUN","TW-TNN","TW-KHH"]'::jsonb),
    ('TW_COUNTIES','TW-PIF','["TW-KHH","TW-TTT"]'::jsonb,'["TW-TNN","TW-CYQ","TW-HUA","TW-PEN"]'::jsonb),
    ('TW_COUNTIES','TW-TXG','["TW-ILA","TW-CHA","TW-NAN","TW-MIA","TW-HUA","TW-HSQ"]'::jsonb,'["TW-TAO","TW-HSZ","TW-YUN","TW-KHH"]'::jsonb),
    ('TW_COUNTIES','TW-TNN','["TW-CYQ","TW-KHH"]'::jsonb,'["TW-YUN","TW-CHA","TW-PIF","TW-PEN"]'::jsonb),
    ('TW_COUNTIES','TW-TPE','["TW-NWT"]'::jsonb,'["TW-KEE","TW-TAO","TW-ILA"]'::jsonb),
    ('TW_COUNTIES','TW-TTT','["TW-KHH","TW-HUA","TW-PIF"]'::jsonb,'["TW-NAN","TW-CYQ","TW-TNN","TW-PEN"]'::jsonb),
    ('TW_COUNTIES','TW-TAO','["TW-ILA","TW-NWT","TW-HSQ"]'::jsonb,'["TW-TPE","TW-KEE","TW-MIA","TW-TXG"]'::jsonb),
    ('TW_COUNTIES','TW-YUN','["TW-CHA","TW-NAN","TW-CYQ"]'::jsonb,'["TW-TXG","TW-MIA","TW-TNN","TW-KHH"]'::jsonb)
) as x("CategoryCode", "TargetItemID", "CorrectItemIDs", "DistractorItemIDs")
  on c."CategoryCode" = x."CategoryCode"
on conflict ("CategoryID", "TargetItemID") do update set
  "CorrectItemIDs" = excluded."CorrectItemIDs",
  "DistractorItemIDs" = excluded."DistractorItemIDs",
  "IsActive" = excluded."IsActive",
  "UpdatedAt" = now();
