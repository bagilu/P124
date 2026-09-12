# P124 Database 執行順序

請在 Supabase SQL Editor 依序執行：

1. `01_CreateTables.sql`
2. `02_CreateIndexes.sql`
3. `03_CreateViews.sql`
4. `04_CreateFunctions.sql`
5. `05_EnableRLS.sql`
6. `06_CreatePolicies.sql`
7. `07_GrantPermissions.sql`
8. `08_SeedData.sql`
9. `09_AddTaiwanCounties.sql`
10. `10_CompleteTaiwanQuestions.sql`
11. `11_AddAfricaAsiaSouthAmericaSamples.sql`
12. `12_CompleteMainlandChinaQuestions.sql`
13. `13_CompleteAsiaQuestions.sql`
14. `14_CompleteAfricaQuestions.sql`
15. `15_CompleteEuropeQuestions.sql`
16. `16_CompleteUSQuestionsAndCategoryOrder.sql`
17. `17_CompleteSouthAmericaQuestions.sql`
18. `18_AddNorthCentralCaribbean.sql`

完成後執行 `99_P124_HealthCheck.sql`。第二與第三段檢查正常時都應回傳 0 rows。

`90_P124_Permissions.sql` 是日後權限異常時使用的 P124 專屬修復檔。

## 從 V0.1／V0.2 升級至 V0.3

如果既有資料表與六道示範題已建立，只需執行：

1. `09_AddTaiwanCounties.sql`
2. `99_P124_HealthCheck.sql`

`09_AddTaiwanCounties.sql` 可重複執行，不會重複建立分類或題目。

## 從 V0.3 升級至 V0.4

只需執行：

1. `10_CompleteTaiwanQuestions.sql`
2. `99_P124_HealthCheck.sql`

`10_CompleteTaiwanQuestions.sql` 可重複執行，會補齊或更新台灣22縣市題目。

## 從 V0.5 升級至 V0.6

若先前已加入非洲、亞洲與南美洲分類，本次只需執行：

1. `14_CompleteAfricaQuestions.sql`
2. `99_P124_HealthCheck.sql`

`14_CompleteAfricaQuestions.sql` 可重複執行，會補齊或更新非洲54國題目。網站預設英文及品牌位置變更則需將 V0.6 網站檔案更新至 GitHub。

## 從 V0.6 升級至 V0.7

請執行：

1. `18_AddNorthCentralCaribbean.sql`
2. `99_P124_HealthCheck.sql`

`18_AddNorthCentralCaribbean.sql` 可重複執行，會新增或更新北美洲、中美洲與加勒比海23個主權國家的完整題目，並將分類順序更新為台灣、亞洲、非洲、歐洲、南美洲、北中美洲與加勒比海、大陸、美國。

本版增加新的 GeoJSON 與網站地圖來源，因此必須將 V0.7 網站檔案更新至 GitHub。

所有 SQL 都只操作 `TblP124Category`、`TblP124Question` 及其 P124 專屬索引、政策，不含影響整個 `public` schema 的全域指令。
