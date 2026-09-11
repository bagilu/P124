-- 1. 基本筆數
select 'Category' as "Object", count(*) as "Rows" from public."TblP124Category"
union all
select 'Question', count(*) from public."TblP124Question";

-- 2. 找出題目、正解或誘答中不存在於分類 Items 的 ID；正常應回傳 0 rows。
with category_items as (
  select c."CategoryID", item->>'id' as "ItemID"
  from public."TblP124Category" c
  cross join lateral jsonb_array_elements(c."Items") item
), question_ids as (
  select q."QuestionID", q."CategoryID", 'target'::text as "Kind", q."TargetItemID" as "ItemID"
  from public."TblP124Question" q
  union all
  select q."QuestionID", q."CategoryID", 'correct', value
  from public."TblP124Question" q
  cross join lateral jsonb_array_elements_text(q."CorrectItemIDs") value
  union all
  select q."QuestionID", q."CategoryID", 'distractor', value
  from public."TblP124Question" q
  cross join lateral jsonb_array_elements_text(q."DistractorItemIDs") value
)
select q.*
from question_ids q
left join category_items i
  on i."CategoryID" = q."CategoryID" and i."ItemID" = q."ItemID"
where i."ItemID" is null;

-- 3. 找出同時被列為正解與誘答的 ID；正常應回傳 0 rows。
select q."QuestionID", overlap_id as "OverlappingItemID"
from public."TblP124Question" q
cross join lateral (
  select c.value as overlap_id
  from jsonb_array_elements_text(q."CorrectItemIDs") c(value)
  inner join jsonb_array_elements_text(q."DistractorItemIDs") d(value)
    on c.value = d.value
) overlap_items;
