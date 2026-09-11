-- P124 V0.1 示範分類與六道題目
-- 題庫示範包括四種相鄰者數量級距。

insert into public."TblP124Category" (
  "CategoryCode", "CategoryNameZh", "CategoryNameEn",
  "DescriptionZh", "DescriptionEn", "Items", "SortOrder", "IsActive"
) values
(
  'CN_PROVINCES',
  '中國大陸省級行政區',
  'Mainland China Divisions',
  '示範中國大陸省級行政區的陸地接壤關係',
  'Land-border relationships among mainland China''s provincial-level divisions',
  $$[
    {"id":"CN-BJ","zh":"北京","en":"Beijing"},{"id":"CN-TJ","zh":"天津","en":"Tianjin"},
    {"id":"CN-HE","zh":"河北","en":"Hebei"},{"id":"CN-SX","zh":"山西","en":"Shanxi"},
    {"id":"CN-NM","zh":"內蒙古","en":"Inner Mongolia"},{"id":"CN-LN","zh":"遼寧","en":"Liaoning"},
    {"id":"CN-JL","zh":"吉林","en":"Jilin"},{"id":"CN-HL","zh":"黑龍江","en":"Heilongjiang"},
    {"id":"CN-SH","zh":"上海","en":"Shanghai"},{"id":"CN-JS","zh":"江蘇","en":"Jiangsu"},
    {"id":"CN-ZJ","zh":"浙江","en":"Zhejiang"},{"id":"CN-AH","zh":"安徽","en":"Anhui"},
    {"id":"CN-FJ","zh":"福建","en":"Fujian"},{"id":"CN-JX","zh":"江西","en":"Jiangxi"},
    {"id":"CN-SD","zh":"山東","en":"Shandong"},{"id":"CN-HA","zh":"河南","en":"Henan"},
    {"id":"CN-HB","zh":"湖北","en":"Hubei"},{"id":"CN-HN","zh":"湖南","en":"Hunan"},
    {"id":"CN-GD","zh":"廣東","en":"Guangdong"},{"id":"CN-GX","zh":"廣西","en":"Guangxi"},
    {"id":"CN-HI","zh":"海南","en":"Hainan"},{"id":"CN-CQ","zh":"重慶","en":"Chongqing"},
    {"id":"CN-SC","zh":"四川","en":"Sichuan"},{"id":"CN-GZ","zh":"貴州","en":"Guizhou"},
    {"id":"CN-YN","zh":"雲南","en":"Yunnan"},{"id":"CN-XZ","zh":"西藏","en":"Tibet"},
    {"id":"CN-SN","zh":"陝西","en":"Shaanxi"},{"id":"CN-GS","zh":"甘肅","en":"Gansu"},
    {"id":"CN-QH","zh":"青海","en":"Qinghai"},{"id":"CN-NX","zh":"寧夏","en":"Ningxia"},
    {"id":"CN-XJ","zh":"新疆","en":"Xinjiang"}
  ]$$::jsonb,
  10,
  true
),
(
  'US_STATES',
  '美國各州',
  'U.S. States',
  '美國各州的陸地接壤關係',
  'Land-border relationships among U.S. states',
  $$[
    {"id":"US-AL","zh":"阿拉巴馬州","en":"Alabama"},{"id":"US-AK","zh":"阿拉斯加州","en":"Alaska"},
    {"id":"US-AZ","zh":"亞利桑那州","en":"Arizona"},{"id":"US-AR","zh":"阿肯色州","en":"Arkansas"},
    {"id":"US-CA","zh":"加利福尼亞州","en":"California"},{"id":"US-CO","zh":"科羅拉多州","en":"Colorado"},
    {"id":"US-CT","zh":"康乃狄克州","en":"Connecticut"},{"id":"US-DE","zh":"德拉瓦州","en":"Delaware"},
    {"id":"US-FL","zh":"佛羅里達州","en":"Florida"},{"id":"US-GA","zh":"喬治亞州","en":"Georgia"},
    {"id":"US-HI","zh":"夏威夷州","en":"Hawaii"},{"id":"US-ID","zh":"愛達荷州","en":"Idaho"},
    {"id":"US-IL","zh":"伊利諾州","en":"Illinois"},{"id":"US-IN","zh":"印第安納州","en":"Indiana"},
    {"id":"US-IA","zh":"愛荷華州","en":"Iowa"},{"id":"US-KS","zh":"堪薩斯州","en":"Kansas"},
    {"id":"US-KY","zh":"肯塔基州","en":"Kentucky"},{"id":"US-LA","zh":"路易斯安那州","en":"Louisiana"},
    {"id":"US-ME","zh":"緬因州","en":"Maine"},{"id":"US-MD","zh":"馬里蘭州","en":"Maryland"},
    {"id":"US-MA","zh":"麻薩諸塞州","en":"Massachusetts"},{"id":"US-MI","zh":"密西根州","en":"Michigan"},
    {"id":"US-MN","zh":"明尼蘇達州","en":"Minnesota"},{"id":"US-MS","zh":"密西西比州","en":"Mississippi"},
    {"id":"US-MO","zh":"密蘇里州","en":"Missouri"},{"id":"US-MT","zh":"蒙大拿州","en":"Montana"},
    {"id":"US-NE","zh":"內布拉斯加州","en":"Nebraska"},{"id":"US-NV","zh":"內華達州","en":"Nevada"},
    {"id":"US-NH","zh":"新罕布夏州","en":"New Hampshire"},{"id":"US-NJ","zh":"紐澤西州","en":"New Jersey"},
    {"id":"US-NM","zh":"新墨西哥州","en":"New Mexico"},{"id":"US-NY","zh":"紐約州","en":"New York"},
    {"id":"US-NC","zh":"北卡羅來納州","en":"North Carolina"},{"id":"US-ND","zh":"北達科他州","en":"North Dakota"},
    {"id":"US-OH","zh":"俄亥俄州","en":"Ohio"},{"id":"US-OK","zh":"奧克拉荷馬州","en":"Oklahoma"},
    {"id":"US-OR","zh":"奧勒岡州","en":"Oregon"},{"id":"US-PA","zh":"賓夕法尼亞州","en":"Pennsylvania"},
    {"id":"US-RI","zh":"羅德島州","en":"Rhode Island"},{"id":"US-SC","zh":"南卡羅來納州","en":"South Carolina"},
    {"id":"US-SD","zh":"南達科他州","en":"South Dakota"},{"id":"US-TN","zh":"田納西州","en":"Tennessee"},
    {"id":"US-TX","zh":"德州","en":"Texas"},{"id":"US-UT","zh":"猶他州","en":"Utah"},
    {"id":"US-VT","zh":"佛蒙特州","en":"Vermont"},{"id":"US-VA","zh":"維吉尼亞州","en":"Virginia"},
    {"id":"US-WA","zh":"華盛頓州","en":"Washington"},{"id":"US-WV","zh":"西維吉尼亞州","en":"West Virginia"},
    {"id":"US-WI","zh":"威斯康辛州","en":"Wisconsin"},{"id":"US-WY","zh":"懷俄明州","en":"Wyoming"}
  ]$$::jsonb,
  20,
  true
),
(
  'EUROPE_COUNTRIES',
  '歐洲國家',
  'European Countries',
  '歐洲國家的陸地接壤關係',
  'Land-border relationships among European countries',
  $$[
    {"id":"EU-AL","zh":"阿爾巴尼亞","en":"Albania"},{"id":"EU-AD","zh":"安道爾","en":"Andorra"},
    {"id":"EU-AT","zh":"奧地利","en":"Austria"},{"id":"EU-BY","zh":"白俄羅斯","en":"Belarus"},
    {"id":"EU-BE","zh":"比利時","en":"Belgium"},{"id":"EU-BA","zh":"波士尼亞與赫塞哥維納","en":"Bosnia and Herzegovina"},
    {"id":"EU-BG","zh":"保加利亞","en":"Bulgaria"},{"id":"EU-HR","zh":"克羅埃西亞","en":"Croatia"},
    {"id":"EU-CZ","zh":"捷克","en":"Czechia"},{"id":"EU-DK","zh":"丹麥","en":"Denmark"},
    {"id":"EU-EE","zh":"愛沙尼亞","en":"Estonia"},{"id":"EU-FI","zh":"芬蘭","en":"Finland"},
    {"id":"EU-FR","zh":"法國","en":"France"},{"id":"EU-DE","zh":"德國","en":"Germany"},
    {"id":"EU-GR","zh":"希臘","en":"Greece"},{"id":"EU-HU","zh":"匈牙利","en":"Hungary"},
    {"id":"EU-IS","zh":"冰島","en":"Iceland"},{"id":"EU-IE","zh":"愛爾蘭","en":"Ireland"},
    {"id":"EU-IT","zh":"義大利","en":"Italy"},{"id":"EU-LV","zh":"拉脫維亞","en":"Latvia"},
    {"id":"EU-LI","zh":"列支敦斯登","en":"Liechtenstein"},{"id":"EU-LT","zh":"立陶宛","en":"Lithuania"},
    {"id":"EU-LU","zh":"盧森堡","en":"Luxembourg"},{"id":"EU-MT","zh":"馬爾他","en":"Malta"},
    {"id":"EU-MD","zh":"摩爾多瓦","en":"Moldova"},{"id":"EU-MC","zh":"摩納哥","en":"Monaco"},
    {"id":"EU-ME","zh":"蒙特內哥羅","en":"Montenegro"},{"id":"EU-NL","zh":"荷蘭","en":"Netherlands"},
    {"id":"EU-MK","zh":"北馬其頓","en":"North Macedonia"},{"id":"EU-NO","zh":"挪威","en":"Norway"},
    {"id":"EU-PL","zh":"波蘭","en":"Poland"},{"id":"EU-PT","zh":"葡萄牙","en":"Portugal"},
    {"id":"EU-RO","zh":"羅馬尼亞","en":"Romania"},{"id":"EU-SM","zh":"聖馬利諾","en":"San Marino"},
    {"id":"EU-RS","zh":"塞爾維亞","en":"Serbia"},{"id":"EU-SK","zh":"斯洛伐克","en":"Slovakia"},
    {"id":"EU-SI","zh":"斯洛維尼亞","en":"Slovenia"},{"id":"EU-ES","zh":"西班牙","en":"Spain"},
    {"id":"EU-SE","zh":"瑞典","en":"Sweden"},{"id":"EU-CH","zh":"瑞士","en":"Switzerland"},
    {"id":"EU-UA","zh":"烏克蘭","en":"Ukraine"},{"id":"EU-GB","zh":"英國","en":"United Kingdom"},
    {"id":"EU-VA","zh":"梵蒂岡","en":"Vatican City"}
  ]$$::jsonb,
  30,
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
    ('CN_PROVINCES', 'CN-QH', '["CN-XJ","CN-GS","CN-SC","CN-XZ"]'::jsonb, '["CN-NX","CN-SN","CN-NM","CN-YN"]'::jsonb),
    ('CN_PROVINCES', 'CN-SC', '["CN-QH","CN-GS","CN-SN","CN-CQ","CN-GZ","CN-YN","CN-XZ"]'::jsonb, '["CN-NX","CN-HB","CN-GX","CN-XJ","CN-HN"]'::jsonb),
    ('US_STATES', 'US-CA', '["US-OR","US-NV","US-AZ"]'::jsonb, '["US-WA","US-UT","US-NM","US-TX"]'::jsonb),
    ('US_STATES', 'US-TN', '["US-KY","US-VA","US-NC","US-GA","US-AL","US-MS","US-AR","US-MO"]'::jsonb, '["US-WV","US-SC","US-OK","US-IL","US-IN"]'::jsonb),
    ('EUROPE_COUNTRIES', 'EU-PT', '["EU-ES"]'::jsonb, '["EU-FR","EU-IT","EU-IE"]'::jsonb),
    ('EUROPE_COUNTRIES', 'EU-DE', '["EU-DK","EU-PL","EU-CZ","EU-AT","EU-CH","EU-FR","EU-LU","EU-BE","EU-NL"]'::jsonb, '["EU-LI","EU-IT","EU-SK","EU-HU","EU-SE","EU-NO"]'::jsonb)
) as x("CategoryCode", "TargetItemID", "CorrectItemIDs", "DistractorItemIDs")
  on c."CategoryCode" = x."CategoryCode"
on conflict ("CategoryID", "TargetItemID") do update set
  "CorrectItemIDs" = excluded."CorrectItemIDs",
  "DistractorItemIDs" = excluded."DistractorItemIDs",
  "IsActive" = excluded."IsActive",
  "UpdatedAt" = now();
