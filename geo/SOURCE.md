# 中國省級行政區邊界資料

- 原始資料：Natural Earth `Admin 1 – States, Provinces`
- 原始版本：5.1.1
- 原始比例尺：1:10m
- 授權：Public Domain
- 來源：https://www.naturalearthdata.com/downloads/10m-cultural-vectors/10m-admin-1-states-provinces/
- 下載日期：2026-09-11

## P124 處理方式

- 僅保留 `CN_PROVINCES` 題庫使用的 31 個中國大陸省級行政區。
- 將地區代碼統一為題庫使用的 ISO 3166-2 代碼。
- 使用拓撲保留簡化，容許值為 `0.025` 度。
- 座標保留小數點後四位。
- 原始 53,214 個邊界頂點簡化為 7,201 個，減少約 86.5%。
- `CN_PROVINCES.geojson` 為標準 GeoJSON；`CN_PROVINCES.js` 是供直接開啟本機 HTML 時使用的同內容包裝檔。

本資料用於地理學習與示意，不作為測量、導航或法律邊界認定用途。

# 台灣縣市界線資料

- 原始資料：直轄市、縣市界線（TWD97經緯度）
- 提供機關：內政部國土測繪中心
- 原始坐標系統：EPSG:3824
- 授權：政府資料開放授權條款第1版（https://data.gov.tw/license）
- 來源：https://data.gov.tw/dataset/7442
- 下載日期：2026-09-11

## P124 處理方式

- 完整保留台灣22個直轄市、縣及市。
- 由 EPSG:3824 轉換為 GeoJSON 使用的 WGS84（EPSG:4326）。
- 地區代碼統一為題庫使用的 ISO 3166-2 形式。
- 使用拓撲保留簡化，容許值為 `0.0015` 度。
- 座標保留小數點後五位。
- 原始328,407個邊界頂點簡化為8,656個，減少約97.4%。
- `TW_COUNTIES.geojson` 為標準 GeoJSON；`TW_COUNTIES.js` 是供直接開啟本機 HTML 時使用的同內容包裝檔。
- 接壤答案依簡化前的官方縣市界線判定；僅共享陸地邊界者列為相鄰。

# P124 V0.5 新增圖資

## 共同來源

- Natural Earth 5.1.1
- 美國各州：`Admin 1 – States, Provinces`
- 各洲國家：`Admin 0 – Countries`
- 原始比例尺：1:10m
- 授權：Public Domain
- 來源：https://www.naturalearthdata.com/downloads/10m-cultural-vectors/
- 下載日期：2026-09-12

## 簡化結果

| 分類代碼 | 收錄單位 | 原始頂點 | 簡化後頂點 | 減少比例 | GeoJSON大小 |
| --- | ---: | ---: | ---: | ---: | ---: |
| `US_STATES` | 50州 | 53,331 | 10,002 | 81.2% | 約199 KB |
| `EUROPE_COUNTRIES` | 現有題庫43國 | 76,960 | 22,519 | 70.7% | 約398 KB |
| `AFRICA_COUNTRIES` | 54國 | 56,129 | 8,770 | 84.4% | 約162 KB |
| `ASIA_COUNTRIES` | 49個國家／地區 | 117,653 | 21,151 | 82.0% | 約388 KB |
| `SOUTH_AMERICA_COUNTRIES` | 12國 | 48,485 | 8,603 | 82.3% | 約165 KB |

## 處理原則

- 美國只保留現有題庫使用的50州，不納入華盛頓哥倫比亞特區。
- 歐洲只保留現有 `EUROPE_COUNTRIES` 分類中的43國；法國、西班牙、葡萄牙、荷蘭及挪威等國的洲外領土不納入歐洲答案地圖。
- 非洲採54個聯合國會員國範圍；西撒哈拉與索馬利蘭的題目歸屬需在建立題庫時另行決定。
- 亞洲依 Natural Earth 洲別並納入巴勒斯坦與台灣；俄羅斯歸屬及跨洲邊界問題留待建立題庫時明訂。
- 南美洲收錄12個主權國家，不把福克蘭群島列為獨立國家題目。
- 顯示用座標採拓撲保留簡化：美國容許值 `0.02` 度、歐洲 `0.012` 度、其他三洲 `0.025` 度；座標保留小數點後四位。
- 每組同時提供標準 `.geojson`，以及供直接開啟本機 HTML 使用的 `.js` 包裝檔。
- 圖資用於地理學習與示意，不作為測量、導航或法律邊界認定用途。

# P124 V0.7 新增圖資

## 北美洲、中美洲與加勒比海國家

- 原始資料：Natural Earth 5.1.1 `Admin 0 – Countries`
- 原始比例尺：1:10m
- 授權：Public Domain
- 來源：https://www.naturalearthdata.com/downloads/10m-cultural-vectors/
- 下載日期：2026-09-12
- 收錄範圍：加拿大、美國、墨西哥、中美洲7國與加勒比海13個主權國家，共23國。
- 不收錄格陵蘭、百慕達、波多黎各等非主權國家或海外領地。
- 使用拓撲保留簡化並保留小型島嶼，座標保留小數點後四位。
- 原始124,348個邊界頂點簡化為14,519個，減少約88.3%；GeoJSON約277 KB。
- `NORTH_CENTRAL_CARIBBEAN_COUNTRIES.geojson` 為標準 GeoJSON；同名 `.js` 為本機直接開啟 HTML 時使用的包裝檔。
