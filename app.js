(function () {
  "use strict";

  const $ = (selector) => document.querySelector(selector);
  const ui = {
    category: $("#categorySelect"), rail: $("#candidateRail"), selectedLayer: $("#selectedLayer"),
    ring: $("#answerRing"), targetName: $("#targetName"), targetLabel: $("#targetLabel"),
    targetHint: $("#targetHint"), feedback: $("#feedback"), candidateCount: $("#candidateCount"),
    selectionCount: $("#selectionCount"), questionNumber: $("#questionNumber"),
    language: $("#languageButton"), badge: $("#dataSourceBadge"), submit: $("#submitButton"),
    reset: $("#resetButton"), next: $("#nextButton"), left: $("#scrollLeft"), right: $("#scrollRight")
  };

  const state = {
    lang: localStorage.getItem("P124Language") || "zh",
    categories: [], questions: [], category: null, question: null, candidates: [], selected: [],
    checked: false, source: "demo", questionIndex: 0
  };

  const copy = {
    zh: {
      sourceDemo: "示範資料", sourceDb: "Supabase資料", eyebrow: "地理接壤挑戰",
      heading: "選出所有相鄰地區", category: "題目分類", candidateKicker: "候選區",
      candidateHeading: "點選或拖曳答案", target: "題目", hint: "與哪些地區接壤？",
      drop: "拖曳至此", selected: (n) => `已選 ${n}`, choices: (n) => `尚有 ${n} 個候選`,
      reset: "重新選擇", submit: "提交答案", next: "下一題",
      instruction: "答案送出前不會顯示正誤。點選已放入的答案可將它移回候選區。",
      empty: "請先選擇至少一個答案。", success: "完全正確！所有相鄰地區都已找出。",
      error: (w, m) => `還差一點：選錯 ${w} 個，遺漏 ${m} 個。可以修正後再次提交。`,
      noQuestion: "這個分類目前沒有可用題目。", switchLabel: "Switch to English",
      question: (n) => `題目 ${String(n).padStart(2, "0")}`
    },
    en: {
      sourceDemo: "Demo data", sourceDb: "Supabase data", eyebrow: "Geographic Border Challenge",
      heading: "Find every bordering region", category: "Question category", candidateKicker: "Candidates",
      candidateHeading: "Tap or drag an answer", target: "QUESTION", hint: "Which regions share a border?",
      drop: "DROP HERE", selected: (n) => `${n} selected`, choices: (n) => `${n} choices remain`,
      reset: "Reset", submit: "Check answer", next: "Next question",
      instruction: "Answers are checked only after submission. Tap a selected answer to return it to the candidate bar.",
      empty: "Select at least one answer first.", success: "Exactly right! You found every bordering region.",
      error: (w, m) => `Almost there: ${w} incorrect and ${m} missing. Revise your choices and try again.`,
      noQuestion: "There are no available questions in this category.", switchLabel: "切換為中文",
      question: (n) => `QUESTION ${String(n).padStart(2, "0")}`
    }
  };

  function randomInt(min, max) { return Math.floor(Math.random() * (max - min + 1)) + min; }
  function shuffle(values) {
    const result = [...values];
    for (let i = result.length - 1; i > 0; i -= 1) {
      const j = Math.floor(Math.random() * (i + 1));
      [result[i], result[j]] = [result[j], result[i]];
    }
    return result;
  }

  function candidateRules(correctCount) {
    if (correctCount <= 3) return {total: randomInt(8, 10), distractors: randomInt(2, 3)};
    if (correctCount <= 6) return {total: randomInt(10, 14), distractors: randomInt(3, 4)};
    if (correctCount <= 8) return {total: randomInt(14, 16), distractors: randomInt(4, 5)};
    return {total: randomInt(16, 18), distractors: randomInt(5, 6)};
  }

  function normalizeCategory(row) {
    return {...row, Items: typeof row.Items === "string" ? JSON.parse(row.Items) : row.Items};
  }

  function normalizeQuestion(row) {
    const parse = (value) => typeof value === "string" ? JSON.parse(value) : value;
    return {...row, CorrectItemIDs: parse(row.CorrectItemIDs), DistractorItemIDs: parse(row.DistractorItemIDs)};
  }

  async function loadFromSupabase(config) {
    if (!config || !/^https:\/\//.test(config.SUPABASE_URL || "") || /YOUR_PROJECT/.test(config.SUPABASE_URL)) return null;
    const headers = {apikey: config.SUPABASE_ANON_KEY, Authorization: `Bearer ${config.SUPABASE_ANON_KEY}`};
    const base = config.SUPABASE_URL.replace(/\/$/, "") + "/rest/v1/";
    const [categoryResponse, questionResponse] = await Promise.all([
      fetch(base + "TblP124Category?select=*&IsActive=eq.true&order=SortOrder.asc", {headers}),
      fetch(base + "TblP124Question?select=*&IsActive=eq.true&order=QuestionID.asc", {headers})
    ]);
    if (!categoryResponse.ok || !questionResponse.ok) throw new Error("Database request failed");
    return {
      categories: (await categoryResponse.json()).map(normalizeCategory),
      questions: (await questionResponse.json()).map(normalizeQuestion)
    };
  }

  function nameFor(item) { return state.lang === "zh" ? item.zh : item.en; }
  function itemMap() { return new Map((state.category?.Items || []).map((item) => [item.id, item])); }

  function buildCandidates(question, category) {
    const correct = [...new Set(question.CorrectItemIDs)];
    const rules = candidateRules(correct.length);
    const preferredPool = shuffle([...new Set(question.DistractorItemIDs)]).filter((id) => !correct.includes(id) && id !== question.TargetItemID);
    const preferred = preferredPool.slice(0, rules.distractors);
    const minimumTotal = correct.length + preferred.length;
    const requestedTotal = Math.max(rules.total, minimumTotal);
    const blocked = new Set([question.TargetItemID, ...correct, ...preferred]);
    const randomPool = shuffle(category.Items.map((item) => item.id).filter((id) => !blocked.has(id)));
    const general = randomPool.slice(0, Math.max(0, requestedTotal - minimumTotal));
    return shuffle([...correct, ...preferred, ...general]);
  }

  function setQuestion(question) {
    state.question = question;
    state.selected = [];
    state.checked = false;
    state.candidates = buildCandidates(question, state.category);
    ui.feedback.className = "feedback";
    ui.feedback.textContent = "";
    render();
  }

  function chooseRandomQuestion(avoidCurrent = false) {
    const available = state.questions.filter((q) => Number(q.CategoryID) === Number(state.category.CategoryID) && q.IsActive !== false);
    if (!available.length) {
      state.question = null;
      render();
      return;
    }
    let choices = available;
    if (avoidCurrent && available.length > 1) choices = available.filter((q) => q.QuestionID !== state.question?.QuestionID);
    const question = choices[Math.floor(Math.random() * choices.length)];
    state.questionIndex += 1;
    setQuestion(question);
  }

  function addAnswer(id) {
    if (!state.question || state.selected.includes(id)) return;
    state.selected.push(id);
    state.checked = false;
    ui.feedback.className = "feedback";
    ui.feedback.textContent = "";
    renderAnswers();
    renderCandidates();
  }

  function removeAnswer(id) {
    state.selected = state.selected.filter((value) => value !== id);
    state.checked = false;
    ui.feedback.className = "feedback";
    ui.feedback.textContent = "";
    renderAnswers();
    renderCandidates();
  }

  function checkAnswer() {
    const t = copy[state.lang];
    if (!state.selected.length) {
      ui.feedback.className = "feedback error";
      ui.feedback.textContent = t.empty;
      return;
    }
    state.checked = true;
    const correct = new Set(state.question.CorrectItemIDs);
    const wrong = state.selected.filter((id) => !correct.has(id));
    const missing = state.question.CorrectItemIDs.filter((id) => !state.selected.includes(id));
    if (!wrong.length && !missing.length) {
      ui.feedback.className = "feedback success";
      ui.feedback.textContent = t.success;
    } else {
      ui.feedback.className = "feedback error";
      ui.feedback.textContent = t.error(wrong.length, missing.length);
    }
    renderAnswers();
    renderCandidates();
  }

  function makeChip(item, selected) {
    const button = document.createElement("button");
    button.type = "button";
    button.className = selected ? "selected-chip" : "candidate-chip";
    button.textContent = nameFor(item);
    button.dataset.id = item.id;
    button.setAttribute("role", "listitem");
    button.draggable = !selected;
    if (!selected) {
      button.addEventListener("click", () => addAnswer(item.id));
      button.addEventListener("dragstart", (event) => event.dataTransfer.setData("text/plain", item.id));
    } else {
      button.setAttribute("aria-label", `${nameFor(item)} — ${state.lang === "zh" ? "移回候選區" : "return to candidates"}`);
      button.addEventListener("click", () => removeAnswer(item.id));
    }
    return button;
  }

  function renderCandidates() {
    if (!state.question) return;
    const map = itemMap();
    const remaining = state.candidates.filter((id) => !state.selected.includes(id));
    ui.rail.innerHTML = "";
    remaining.forEach((id) => {
      const item = map.get(id);
      if (!item) return;
      const chip = makeChip(item, false);
      if (state.checked && state.question.CorrectItemIDs.includes(id)) chip.classList.add("missing");
      ui.rail.appendChild(chip);
    });
    ui.candidateCount.textContent = copy[state.lang].choices(remaining.length);
  }

  function placeOnPerimeter(element, index, total) {
    const box = ui.ring.getBoundingClientRect();
    const chipWidth = element.offsetWidth || 80;
    const chipHeight = element.offsetHeight || 38;
    const insetX = chipWidth / 2 + 12;
    const insetY = chipHeight / 2 + 12;
    const left = insetX;
    const right = box.width - insetX;
    const top = insetY;
    const bottom = box.height - insetY;
    const width = Math.max(1, right - left);
    const height = Math.max(1, bottom - top);
    const perimeter = 2 * (width + height);
    let distance = ((index + 0.5) / total) * perimeter;
    let x, y;
    if (distance <= width) { x = left + distance; y = top; }
    else if ((distance -= width) <= height) { x = right; y = top + distance; }
    else if ((distance -= height) <= width) { x = right - distance; y = bottom; }
    else { distance -= width; x = left; y = bottom - distance; }
    element.style.left = `${x}px`;
    element.style.top = `${y}px`;
    element.style.transform = "translate(-50%, -50%)";
  }

  function layoutSelected() {
    const chips = [...ui.selectedLayer.children];
    chips.forEach((chip, index) => placeOnPerimeter(chip, index, chips.length));
  }

  function renderAnswers() {
    if (!state.question) return;
    const map = itemMap();
    const correct = new Set(state.question.CorrectItemIDs);
    ui.selectedLayer.innerHTML = "";
    state.selected.forEach((id) => {
      const item = map.get(id);
      if (!item) return;
      const chip = makeChip(item, true);
      if (state.checked) chip.classList.add(correct.has(id) ? "correct" : "wrong");
      ui.selectedLayer.appendChild(chip);
    });
    ui.selectionCount.textContent = copy[state.lang].selected(state.selected.length);
    requestAnimationFrame(layoutSelected);
  }

  function renderStaticCopy() {
    const t = copy[state.lang];
    document.documentElement.lang = state.lang === "zh" ? "zh-Hant" : "en";
    $("#eyebrow").textContent = t.eyebrow;
    $("#gameHeading").textContent = t.heading;
    $("#categoryLabel").textContent = t.category;
    $("#candidateKicker").textContent = t.candidateKicker;
    $("#candidateHeading").textContent = t.candidateHeading;
    ui.targetLabel.textContent = t.target;
    ui.targetHint.textContent = t.hint;
    $("#dropHint").textContent = t.drop;
    ui.reset.textContent = t.reset;
    ui.submit.textContent = t.submit;
    ui.next.textContent = t.next;
    $("#instruction").textContent = t.instruction;
    ui.language.textContent = state.lang === "zh" ? "EN" : "中";
    ui.language.setAttribute("aria-label", t.switchLabel);
    ui.badge.textContent = state.source === "database" ? t.sourceDb : t.sourceDemo;
  }

  function renderCategoryOptions() {
    const current = state.category?.CategoryID;
    ui.category.innerHTML = "";
    state.categories.forEach((category) => {
      const option = document.createElement("option");
      option.value = category.CategoryID;
      option.textContent = state.lang === "zh" ? category.CategoryNameZh : category.CategoryNameEn;
      option.selected = Number(category.CategoryID) === Number(current);
      ui.category.appendChild(option);
    });
  }

  function render() {
    renderStaticCopy();
    renderCategoryOptions();
    const t = copy[state.lang];
    if (!state.question) {
      ui.targetName.textContent = "—";
      ui.feedback.textContent = t.noQuestion;
      ui.submit.disabled = true;
      ui.next.disabled = true;
      return;
    }
    const target = itemMap().get(state.question.TargetItemID);
    ui.targetName.textContent = target ? nameFor(target) : state.question.TargetItemID;
    ui.questionNumber.textContent = t.question(state.questionIndex);
    ui.submit.disabled = false;
    ui.next.disabled = false;
    renderCandidates();
    renderAnswers();
  }

  function bindEvents() {
    ui.category.addEventListener("change", () => {
      state.category = state.categories.find((item) => Number(item.CategoryID) === Number(ui.category.value));
      chooseRandomQuestion(false);
    });
    ui.language.addEventListener("click", () => {
      state.lang = state.lang === "zh" ? "en" : "zh";
      localStorage.setItem("P124Language", state.lang);
      render();
    });
    ui.submit.addEventListener("click", checkAnswer);
    ui.reset.addEventListener("click", () => {
      state.selected = [];
      state.checked = false;
      ui.feedback.className = "feedback";
      ui.feedback.textContent = "";
      renderAnswers();
      renderCandidates();
    });
    ui.next.addEventListener("click", () => chooseRandomQuestion(true));
    ui.left.addEventListener("click", () => ui.rail.scrollBy({left: -280, behavior: "smooth"}));
    ui.right.addEventListener("click", () => ui.rail.scrollBy({left: 280, behavior: "smooth"}));
    ui.ring.addEventListener("dragover", (event) => { event.preventDefault(); ui.ring.classList.add("drag-over"); });
    ui.ring.addEventListener("dragleave", () => ui.ring.classList.remove("drag-over"));
    ui.ring.addEventListener("drop", (event) => {
      event.preventDefault();
      ui.ring.classList.remove("drag-over");
      addAnswer(event.dataTransfer.getData("text/plain"));
    });
    window.addEventListener("resize", () => requestAnimationFrame(layoutSelected));
  }

  async function init() {
    bindEvents();
    let data = window.P124_DEMO_DATA;
    try {
      const config = await window.P124_CONFIG_READY;
      const databaseData = await loadFromSupabase(config);
      if (databaseData?.categories?.length && databaseData?.questions?.length) {
        data = databaseData;
        state.source = "database";
      }
    } catch (error) {
      console.warn("P124 is using bundled demo data.", error);
    }
    state.categories = data.categories.map(normalizeCategory).filter((item) => item.IsActive !== false);
    state.questions = data.questions.map(normalizeQuestion).filter((item) => item.IsActive !== false);
    state.category = state.categories[0] || null;
    chooseRandomQuestion(false);
  }

  init();
})();
