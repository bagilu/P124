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

完成後執行 `99_P124_HealthCheck.sql`。第二與第三段檢查正常時都應回傳 0 rows。

`90_P124_Permissions.sql` 是日後權限異常時使用的 P124 專屬修復檔。

## 從 V0.1／V0.2 升級至 V0.3

如果既有資料表與六道示範題已建立，只需執行：

1. `09_AddTaiwanCounties.sql`
2. `99_P124_HealthCheck.sql`

`09_AddTaiwanCounties.sql` 可重複執行，不會重複建立分類或題目。

所有 SQL 都只操作 `TblP124Category`、`TblP124Question` 及其 P124 專屬索引、政策，不含影響整個 `public` schema 的全域指令。
