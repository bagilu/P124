# P124 誰是鄰居｜Who Borders V0.3

手機優先的雙語地理接壤辨識遊戲。候選答案位於上方可左右滑動的橫幅；點選或拖曳答案後，答案會排列在中央題目的圓角同心框周圍。

## V0.3 功能

- 中英文介面切換。
- 題目大分類選擇。
- 點選答案及桌機拖曳作答。
- 提交前不顯示正誤。
- 完整比對錯選與遺漏答案。
- 依正確相鄰者數量，自動決定候選總數及人工誘答數。
- 內建九題示範資料；尚未連接 Supabase 也可直接試玩。
- Supabase 兩表 Schema、RLS、權限、示範 INSERT 與健康檢查。
- 中國大陸省級行政區答案地圖，首批支援青海與四川題目。
- 送出答案後，自動顯示題目地區、全部正確鄰居與誤選地區。
- 地圖名稱隨介面切換繁體中文或英文。
- 支援滑鼠、觸控拖曳及縮放；畫面自動對準題目與正確鄰居。
- 地圖資料延遲載入，不會影響尚未作答時的初始畫面。
- 內附簡化後的 GeoJSON，邊界頂點減少約 86.5%。
- 新增「台灣縣市」分類，完整收錄22個縣市候選項目。
- 新增花蓮縣、嘉義縣、臺北市三道示範題及答案地圖。
- 台灣邊界採內政部國土測繪中心開放資料，轉為 WGS84 並簡化約97.4%。

美國各州與歐洲國家題目仍可正常遊玩，但 V0.3 尚未顯示答案地圖。

## 候選數量規則

| 正確相鄰者 | 候選總數 | 人工誘答數 |
| --- | --- | --- |
| 1–3 | 8–10 | 2–3 |
| 4–6 | 10–14 | 3–4 |
| 7–8 | 14–16 | 4–5 |
| 9以上 | 16–18 | 5–6 |

每次出題會在區間內重新隨機。若正確答案加人工誘答已超過候選上限，系統會自動擴大候選總數，確保正確答案完整呈現。

## 直接試玩

將本資料夾部署到 GitHub Pages，或以任何靜態網站伺服器開啟。未設定 Supabase 時，網站會自動使用 `demo-data.js`。

## 連接 Supabase

1. 依照 `database/README.md` 的順序執行 SQL。
2. 複製 `config-sample.js` 並命名為 `config.js`。
3. 填入 Supabase URL 與 anon key。
4. 不要將 `config.js` 當作版本庫範本提交；ZIP 已透過 `.gitignore` 排除它。

網站只使用 anon key 讀取已啟用的題目。匿名使用者沒有新增、修改或刪除題庫的權限。

## 檔案結構

```text
index.html
styles.css
app.js
demo-data.js
config-sample.js
geo/
  CN_PROVINCES.geojson
  CN_PROVINCES.js
  TW_COUNTIES.geojson
  TW_COUNTIES.js
  SOURCE.md
vendor/
  leaflet.css
  leaflet.js
  LEAFLET_LICENSE.txt
database/
  01_CreateTables.sql
  02_CreateIndexes.sql
  03_CreateViews.sql
  04_CreateFunctions.sql
  05_EnableRLS.sql
  06_CreatePolicies.sql
  07_GrantPermissions.sql
  08_SeedData.sql
  09_AddTaiwanCounties.sql
  90_P124_Permissions.sql
  99_P124_HealthCheck.sql
```

## 品牌

慈濟大學 經營管理學系｜好玩實驗室 作品

## 地圖資料與元件

- 中國大陸省級行政區邊界：Natural Earth 5.1.1，Public Domain。
- 台灣縣市界線：內政部國土測繪中心，政府資料開放授權條款第1版。
- 地圖互動：Leaflet 1.9.4，BSD-2-Clause。
- 地圖僅供教學示意；政治邊界呈現遵循所採資料來源，不作為法律認定。
