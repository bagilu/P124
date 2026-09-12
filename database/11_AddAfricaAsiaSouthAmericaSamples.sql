-- P124 V0.5 題庫增量：新增非洲、亞洲、南美洲分類與各兩道示範題。
-- 適用於已部署 P124 V0.5 圖資的網站；可重複執行。

insert into public."TblP124Category" (
  "CategoryCode", "CategoryNameZh", "CategoryNameEn",
  "DescriptionZh", "DescriptionEn", "Items", "SortOrder", "IsActive"
) values
(
  'AFRICA_COUNTRIES', '非洲國家', 'African Countries',
  '非洲54國的陸地接壤關係', 'Land-border relationships among 54 African countries',
  $$[{"id":"AF-AO","zh":"安哥拉","en":"Angola"},{"id":"AF-BF","zh":"布基納法索","en":"Burkina Faso"},{"id":"AF-BI","zh":"蒲隆地","en":"Burundi"},{"id":"AF-BJ","zh":"貝南","en":"Benin"},{"id":"AF-BW","zh":"波札那","en":"Botswana"},{"id":"AF-CD","zh":"剛果民主共和國","en":"Democratic Republic of the Congo"},{"id":"AF-CF","zh":"中非共和國","en":"Central African Republic"},{"id":"AF-CG","zh":"剛果共和國","en":"Republic of the Congo"},{"id":"AF-CI","zh":"象牙海岸","en":"Ivory Coast"},{"id":"AF-CM","zh":"喀麥隆","en":"Cameroon"},{"id":"AF-CV","zh":"維德角","en":"Cape Verde"},{"id":"AF-DJ","zh":"吉布地","en":"Djibouti"},{"id":"AF-DZ","zh":"阿爾及利亞","en":"Algeria"},{"id":"AF-EG","zh":"埃及","en":"Egypt"},{"id":"AF-ER","zh":"厄利垂亞","en":"Eritrea"},{"id":"AF-ET","zh":"衣索比亞","en":"Ethiopia"},{"id":"AF-GA","zh":"加彭","en":"Gabon"},{"id":"AF-GH","zh":"迦納","en":"Ghana"},{"id":"AF-GM","zh":"甘比亞","en":"The Gambia"},{"id":"AF-GN","zh":"幾內亞","en":"Guinea"},{"id":"AF-GQ","zh":"赤道幾內亞","en":"Equatorial Guinea"},{"id":"AF-GW","zh":"幾內亞比索","en":"Guinea-Bissau"},{"id":"AF-KE","zh":"肯亞","en":"Kenya"},{"id":"AF-KM","zh":"葛摩","en":"Comoros"},{"id":"AF-LR","zh":"賴比瑞亞","en":"Liberia"},{"id":"AF-LS","zh":"賴索托","en":"Lesotho"},{"id":"AF-LY","zh":"利比亞","en":"Libya"},{"id":"AF-MA","zh":"摩洛哥","en":"Morocco"},{"id":"AF-MG","zh":"馬達加斯加","en":"Madagascar"},{"id":"AF-ML","zh":"馬利共和國","en":"Mali"},{"id":"AF-MR","zh":"茅利塔尼亞","en":"Mauritania"},{"id":"AF-MU","zh":"模里西斯","en":"Mauritius"},{"id":"AF-MW","zh":"馬拉威","en":"Malawi"},{"id":"AF-MZ","zh":"莫三比克","en":"Mozambique"},{"id":"AF-NA","zh":"納米比亞","en":"Namibia"},{"id":"AF-NE","zh":"尼日","en":"Niger"},{"id":"AF-NG","zh":"奈及利亞","en":"Nigeria"},{"id":"AF-RW","zh":"盧安達","en":"Rwanda"},{"id":"AF-SC","zh":"塞席爾","en":"Seychelles"},{"id":"AF-SD","zh":"蘇丹","en":"Sudan"},{"id":"AF-SL","zh":"獅子山","en":"Sierra Leone"},{"id":"AF-SN","zh":"塞內加爾","en":"Senegal"},{"id":"AF-SO","zh":"索馬利亞","en":"Somalia"},{"id":"AF-SS","zh":"南蘇丹","en":"South Sudan"},{"id":"AF-ST","zh":"聖多美普林西比","en":"São Tomé and Príncipe"},{"id":"AF-SZ","zh":"史瓦帝尼","en":"Eswatini"},{"id":"AF-TD","zh":"查德","en":"Chad"},{"id":"AF-TG","zh":"多哥","en":"Togo"},{"id":"AF-TN","zh":"突尼西亞","en":"Tunisia"},{"id":"AF-TZ","zh":"坦尚尼亞","en":"Tanzania"},{"id":"AF-UG","zh":"烏干達","en":"Uganda"},{"id":"AF-ZA","zh":"南非","en":"South Africa"},{"id":"AF-ZM","zh":"尚比亞","en":"Zambia"},{"id":"AF-ZW","zh":"辛巴威","en":"Zimbabwe"},{"id":"AF-NONE","zh":"無陸地相鄰國家","en":"No land-border neighbors"}]$$::jsonb,
  50, true
),
(
  'ASIA_COUNTRIES', '亞洲國家', 'Asian Countries',
  '亞洲49個國家與地區的陸地接壤關係', 'Land-border relationships among 49 Asian countries and regions',
  $$[{"id":"AS-AE","zh":"阿拉伯聯合大公國","en":"United Arab Emirates"},{"id":"AS-AF","zh":"阿富汗","en":"Afghanistan"},{"id":"AS-AM","zh":"亞美尼亞","en":"Armenia"},{"id":"AS-AZ","zh":"亞塞拜然","en":"Azerbaijan"},{"id":"AS-BD","zh":"孟加拉","en":"Bangladesh"},{"id":"AS-BH","zh":"巴林","en":"Bahrain"},{"id":"AS-BN","zh":"汶萊","en":"Brunei"},{"id":"AS-BT","zh":"不丹","en":"Bhutan"},{"id":"AS-CN","zh":"中國","en":"China"},{"id":"AS-CY","zh":"賽普勒斯","en":"Cyprus"},{"id":"AS-GE","zh":"喬治亞","en":"Georgia"},{"id":"AS-ID","zh":"印度尼西亞","en":"Indonesia"},{"id":"AS-IL","zh":"以色列","en":"Israel"},{"id":"AS-IN","zh":"印度","en":"India"},{"id":"AS-IQ","zh":"伊拉克","en":"Iraq"},{"id":"AS-IR","zh":"伊朗","en":"Iran"},{"id":"AS-JO","zh":"約旦","en":"Jordan"},{"id":"AS-JP","zh":"日本","en":"Japan"},{"id":"AS-KG","zh":"吉爾吉斯","en":"Kyrgyzstan"},{"id":"AS-KH","zh":"柬埔寨","en":"Cambodia"},{"id":"AS-KP","zh":"北韓","en":"North Korea"},{"id":"AS-KR","zh":"南韓","en":"South Korea"},{"id":"AS-KW","zh":"科威特","en":"Kuwait"},{"id":"AS-KZ","zh":"哈薩克","en":"Kazakhstan"},{"id":"AS-LA","zh":"寮國","en":"Laos"},{"id":"AS-LB","zh":"黎巴嫩","en":"Lebanon"},{"id":"AS-LK","zh":"斯里蘭卡","en":"Sri Lanka"},{"id":"AS-MM","zh":"緬甸","en":"Myanmar"},{"id":"AS-MN","zh":"蒙古","en":"Mongolia"},{"id":"AS-MV","zh":"馬爾地夫","en":"Maldives"},{"id":"AS-MY","zh":"馬來西亞","en":"Malaysia"},{"id":"AS-NP","zh":"尼泊爾","en":"Nepal"},{"id":"AS-OM","zh":"阿曼","en":"Oman"},{"id":"AS-PH","zh":"菲律賓","en":"Philippines"},{"id":"AS-PK","zh":"巴基斯坦","en":"Pakistan"},{"id":"AS-PS","zh":"巴勒斯坦","en":"Palestine"},{"id":"AS-QA","zh":"卡達","en":"Qatar"},{"id":"AS-SA","zh":"沙烏地阿拉伯","en":"Saudi Arabia"},{"id":"AS-SG","zh":"新加坡","en":"Singapore"},{"id":"AS-SY","zh":"敘利亞","en":"Syria"},{"id":"AS-TH","zh":"泰國","en":"Thailand"},{"id":"AS-TJ","zh":"塔吉克","en":"Tajikistan"},{"id":"AS-TL","zh":"東帝汶","en":"Timor-Leste"},{"id":"AS-TM","zh":"土庫曼","en":"Turkmenistan"},{"id":"AS-TR","zh":"土耳其","en":"Turkey"},{"id":"AS-TW","zh":"台灣","en":"Taiwan"},{"id":"AS-UZ","zh":"烏茲別克","en":"Uzbekistan"},{"id":"AS-VN","zh":"越南","en":"Vietnam"},{"id":"AS-YE","zh":"葉門","en":"Yemen"},{"id":"AS-NONE","zh":"無陸地相鄰國家","en":"No land-border neighbors"}]$$::jsonb,
  60, true
),
(
  'SOUTH_AMERICA_COUNTRIES', '南美洲國家', 'South American Countries',
  '南美洲12國的陸地接壤關係', 'Land-border relationships among 12 South American countries',
  $$[{"id":"SA-AR","zh":"阿根廷","en":"Argentina"},{"id":"SA-BO","zh":"玻利維亞","en":"Bolivia"},{"id":"SA-BR","zh":"巴西","en":"Brazil"},{"id":"SA-CL","zh":"智利","en":"Chile"},{"id":"SA-CO","zh":"哥倫比亞","en":"Colombia"},{"id":"SA-EC","zh":"厄瓜多爾","en":"Ecuador"},{"id":"SA-GY","zh":"蓋亞那","en":"Guyana"},{"id":"SA-PE","zh":"秘魯","en":"Peru"},{"id":"SA-PY","zh":"巴拉圭","en":"Paraguay"},{"id":"SA-SR","zh":"蘇利南","en":"Suriname"},{"id":"SA-UY","zh":"烏拉圭","en":"Uruguay"},{"id":"SA-VE","zh":"委內瑞拉","en":"Venezuela"},{"id":"SA-NONE","zh":"無陸地相鄰國家","en":"No land-border neighbors"}]$$::jsonb,
  70, true
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
    ('AFRICA_COUNTRIES','AF-KE','["AF-ET","AF-SO","AF-SS","AF-UG","AF-TZ"]'::jsonb,'["AF-RW","AF-CD","AF-SD","AF-MZ"]'::jsonb),
    ('AFRICA_COUNTRIES','AF-NG','["AF-BJ","AF-NE","AF-TD","AF-CM"]'::jsonb,'["AF-TG","AF-GH","AF-CF","AF-BF"]'::jsonb),
    ('ASIA_COUNTRIES','AS-TH','["AS-MM","AS-LA","AS-KH","AS-MY"]'::jsonb,'["AS-VN","AS-BD","AS-SG","AS-CN"]'::jsonb),
    ('ASIA_COUNTRIES','AS-NP','["AS-CN","AS-IN"]'::jsonb,'["AS-BT","AS-BD","AS-PK","AS-MM"]'::jsonb),
    ('SOUTH_AMERICA_COUNTRIES','SA-CL','["SA-PE","SA-BO","SA-AR"]'::jsonb,'["SA-BR","SA-PY","SA-UY","SA-EC"]'::jsonb),
    ('SOUTH_AMERICA_COUNTRIES','SA-UY','["SA-AR","SA-BR"]'::jsonb,'["SA-PY","SA-CL","SA-BO","SA-PE"]'::jsonb)
) as x("CategoryCode", "TargetItemID", "CorrectItemIDs", "DistractorItemIDs")
  on c."CategoryCode" = x."CategoryCode"
on conflict ("CategoryID", "TargetItemID") do update set
  "CorrectItemIDs" = excluded."CorrectItemIDs",
  "DistractorItemIDs" = excluded."DistractorItemIDs",
  "IsActive" = excluded."IsActive",
  "UpdatedAt" = now();
