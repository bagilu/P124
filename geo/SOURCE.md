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
