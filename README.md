# P124 誰是鄰居｜Who Borders V0.8

手機優先的雙語地理接壤辨識遊戲。候選答案位於上方可左右滑動的橫幅；點選或拖曳答案後，答案會排列在中央題目的圓角同心框周圍。

## V0.8 功能

- 中英文介面切換。
- 首次開啟預設使用英文；切換後會記住使用者選擇。
- 實驗室品牌連結由頁尾移至左上方、位於系統名稱右側。
- 新增5題、10題與20題挑戰模式，預設為10題。
- 畫面持續顯示挑戰區域、累計題數、累計分數、目前連勝與本機最高分。
- 每題只有第一次提交計分；之後仍可修正答案與查看地圖，但不會重新加分。
- 每題最高100分，使用同時衡量命中、誤選與漏選的F1型集合計分。
- 挑戰結束顯示結果卡，包括總分、完全正確題數、最佳連勝與本機最高分。
- 本機最高分依「分類＋挑戰題數」分別保存在瀏覽器中，不需帳號或新增資料表。
- 同一輪題目全部出完前不重複；題庫少於挑戰題數時，才會重新洗牌進入下一輪。
- 題目大分類選擇。
- 點選答案及桌機拖曳作答。
- 提交前不顯示正誤。
- 完整比對錯選與遺漏答案。
- 依正確相鄰者數量，自動決定候選總數及人工誘答數。
- 內建51題資料；尚未連接 Supabase 也可直接試玩。
- Supabase 兩表 Schema、RLS、權限、示範 INSERT 與健康檢查。
- 中國大陸省級行政區答案地圖，首批支援青海與四川題目。
- 送出答案後，自動顯示題目地區、全部正確鄰居與誤選地區。
- 地圖名稱隨介面切換繁體中文或英文。
- 支援滑鼠、觸控拖曳及縮放；畫面自動對準題目與正確鄰居。
- 地圖資料延遲載入，不會影響尚未作答時的初始畫面。
- 內附簡化後的 GeoJSON，邊界頂點減少約 86.5%。
- 「台灣縣市」分類已完成全部22個縣市題目與答案地圖。
- 金門縣、連江縣與澎湖縣使用「無陸地相鄰縣市」作為正確答案。
- 特殊答案不會混入其他縣市題目的隨機候選項目。
- 台灣邊界採內政部國土測繪中心開放資料，轉為 WGS84 並簡化約97.4%。
- 新增美國50州答案地圖，現有加州與田納西州題目可直接顯示。
- 新增歐洲43國答案地圖，現有葡萄牙與德國題目可直接顯示。
- 預先建立非洲54國、亞洲49個國家／地區、南美洲12國的簡化圖資。
- 新增「北美洲、中美洲與加勒比海國家」分類，收錄23個主權國家及完整題目。
- 加勒比海島國仍完整收錄；海地與多明尼加彼此接壤，其餘11個島國使用「無陸地相鄰國家」。
- 北美洲、中美洲與加勒比海圖資由124,348個頂點簡化為14,519個，減少約88.3%。
- 所有地圖按分類延遲載入，不會在開啟網站時一次下載。

目前各分類均可顯示答案地圖；完整題庫可透過 `database/10` 至 `database/18` 的增量 SQL 逐步加入。

## 挑戰計分

每題分數為：

```text
round(100 × 2H ÷ (2H + W + M))
```

- `H`：命中的正確答案數。
- `W`：多選的錯誤答案數。
- `M`：漏選的正確答案數。

完全正確為100分；完全沒有命中為0分。挑戰分數只在第一次提交時計算，修改答案不會改變既有分數。

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

### 從 V0.3 升級

既有 V0.3 資料庫只需執行 `database/10_CompleteTaiwanQuestions.sql`，再執行 `database/99_P124_HealthCheck.sql`；不必重新建立資料表。

### 從 V0.7 升級至 V0.8

挑戰模式完全由前端執行，本機最高分保存在瀏覽器的 localStorage，不增加資料表或權限。將 V0.8 網站檔案更新至 GitHub 即可，不需要執行新的 SQL。

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
  US_STATES.geojson
  US_STATES.js
  EUROPE_COUNTRIES.geojson
  EUROPE_COUNTRIES.js
  AFRICA_COUNTRIES.geojson
  AFRICA_COUNTRIES.js
  ASIA_COUNTRIES.geojson
  ASIA_COUNTRIES.js
  SOUTH_AMERICA_COUNTRIES.geojson
  SOUTH_AMERICA_COUNTRIES.js
  NORTH_CENTRAL_CARIBBEAN_COUNTRIES.geojson
  NORTH_CENTRAL_CARIBBEAN_COUNTRIES.js
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
  10_CompleteTaiwanQuestions.sql
  11_AddAfricaAsiaSouthAmericaSamples.sql
  12_CompleteMainlandChinaQuestions.sql
  13_CompleteAsiaQuestions.sql
  14_CompleteAfricaQuestions.sql
  15_CompleteEuropeQuestions.sql
  16_CompleteUSQuestionsAndCategoryOrder.sql
  17_CompleteSouthAmericaQuestions.sql
  18_AddNorthCentralCaribbean.sql
  90_P124_Permissions.sql
  99_P124_HealthCheck.sql
```

## 品牌

慈濟大學 經營管理學系｜好玩實驗室 作品

## 地圖資料與元件

- 中國大陸省級行政區邊界：Natural Earth 5.1.1，Public Domain。
- 台灣縣市界線：內政部國土測繪中心，政府資料開放授權條款第1版。
- 美國各州、歐洲、非洲、亞洲、南美洲、北美洲、中美洲與加勒比海：Natural Earth 5.1.1，Public Domain。
- 地圖互動：Leaflet 1.9.4，BSD-2-Clause。
- 地圖僅供教學示意；政治邊界呈現遵循所採資料來源，不作為法律認定。
