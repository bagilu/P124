(function () {
  "use strict";

  const $ = (selector) => document.querySelector(selector);
  const ui = {
    category: $("#categorySelect"), rail: $("#candidateRail"), selectedLayer: $("#selectedLayer"),
    ring: $("#answerRing"), targetName: $("#targetName"), targetLabel: $("#targetLabel"),
    targetHint: $("#targetHint"), feedback: $("#feedback"), candidateCount: $("#candidateCount"),
    selectionCount: $("#selectionCount"), questionNumber: $("#questionNumber"),
    language: $("#languageButton"), badge: $("#dataSourceBadge"), submit: $("#submitButton"),
    reset: $("#resetButton"), next: $("#nextButton"), left: $("#scrollLeft"), right: $("#scrollRight"),
    mapPanel: $("#answerMapPanel"), map: $("#answerMap"), mapHeading: $("#answerMapHeading"),
    mapKicker: $("#answerMapKicker"), legendTarget: $("#legendTarget"),
    legendCorrect: $("#legendCorrect"), legendWrong: $("#legendWrong"),
    legendWrongItem: $("#legendWrongItem"), mapSource: $("#mapSource")
  };

  const state = {
    lang: localStorage.getItem("P124Language") || "zh",
    categories: [], questions: [], category: null, question: null, candidates: [], selected: [],
    checked: false, source: "demo", questionIndex: 0,
    geoData: new Map(), answerMap: null, answerMapLayer: null, answerLabelLayer: null, mapRequest: 0
  };

  const mapFiles = {
    CN_PROVINCES: "geo/CN_PROVINCES.geojson",
    TW_COUNTIES: "geo/TW_COUNTIES.geojson"
  };

  const mapSources = {
    CN_PROVINCES: {
      zh: "邊界資料：Natural Earth（已簡化）",
      en: "Boundary data: Natural Earth (simplified)",
      url: "https://www.naturalearthdata.com/"
    },
    TW_COUNTIES: {
      zh: "邊界資料：內政部國土測繪中心（已簡化）",
      en: "Boundary data: National Land Surveying and Mapping Center (simplified)",
      url: "https://data.gov.tw/dataset/7442"
    }
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
      question: (n) => `題目 ${String(n).padStart(2, "0")}`,
      mapKicker: "答案地圖", mapHeading: "正確的相鄰地區", mapTarget: "題目地區",
      mapCorrect: "正確鄰居", mapWrong: "誤選地區"
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
      question: (n) => `QUESTION ${String(n).padStart(2, "0")}`,
      mapKicker: "ANSWER MAP", mapHeading: "The correct bordering regions", mapTarget: "Target",
      mapCorrect: "Correct neighbors", mapWrong: "Incorrect choices"
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

  function escapeHtml(value) {
    return String(value).replace(/[&<>'"]/g, (character) => ({
      "&": "&amp;", "<": "&lt;", ">": "&gt;", "'": "&#39;", '"': "&quot;"
    })[character]);
  }

  function hideAnswerMap() {
    state.mapRequest += 1;
    ui.mapPanel.hidden = true;
  }

  function loadGeoScript(categoryCode, geoJsonPath) {
    return new Promise((resolve, reject) => {
      const script = document.createElement("script");
      script.src = geoJsonPath.replace(/\.geojson$/, ".js");
      script.onload = () => resolve(window.P124_GEO_DATA?.[categoryCode] || null);
      script.onerror = reject;
      document.head.appendChild(script);
    });
  }

  async function loadGeoData(categoryCode) {
    if (state.geoData.has(categoryCode)) return state.geoData.get(categoryCode);
    const path = mapFiles[categoryCode];
    if (!path) return null;
    let data = null;
    try {
      const response = await fetch(path);
      if (!response.ok) throw new Error("Map request failed");
      data = await response.json();
    } catch (error) {
      data = await loadGeoScript(categoryCode, path);
    }
    if (data) state.geoData.set(categoryCode, data);
    return data;
  }

  function ensureAnswerMap() {
    if (state.answerMap || !window.L) return state.answerMap;
    state.answerMap = L.map(ui.map, {
      attributionControl: false,
      minZoom: 2,
      maxZoom: 8,
      zoomSnap: 0.25,
      scrollWheelZoom: true
    });
    return state.answerMap;
  }

  function answerMapStyle(feature, targetId, correctIds, wrongIds) {
    const id = feature.properties.id;
    if (id === targetId) return {color: "#fff0b8", weight: 2.2, fillColor: "#ffc857", fillOpacity: .9};
    if (correctIds.has(id)) return {color: "#d8fffa", weight: 1.8, fillColor: "#42d6c4", fillOpacity: .76};
    if (wrongIds.has(id)) return {color: "#ffd7d7", weight: 1.8, fillColor: "#ff7373", fillOpacity: .72};
    return {color: "#66839a", weight: .75, fillColor: "#17334a", fillOpacity: .38};
  }

  async function renderAnswerMap() {
    const categoryCode = state.category?.CategoryCode;
    if (!state.checked || !mapFiles[categoryCode]) {
      hideAnswerMap();
      return;
    }
    const requestId = ++state.mapRequest;
    try {
      const data = await loadGeoData(categoryCode);
      if (!data || requestId !== state.mapRequest || !state.checked) return;
      const map = ensureAnswerMap();
      if (!map) return;
      const targetId = state.question.TargetItemID;
      const correctIds = new Set(state.question.CorrectItemIDs);
      const wrongIds = new Set(state.selected.filter((id) => !correctIds.has(id)));
      const labeledIds = new Set([targetId, ...correctIds, ...wrongIds]);
      const focusIds = new Set([targetId, ...correctIds]);
      if (state.answerMapLayer) state.answerMapLayer.remove();
      if (state.answerLabelLayer) state.answerLabelLayer.remove();
      state.answerMapLayer = L.geoJSON(data, {
        style: (feature) => answerMapStyle(feature, targetId, correctIds, wrongIds),
        interactive: false
      }).addTo(map);
      state.answerLabelLayer = L.layerGroup();
      data.features.filter((feature) => labeledIds.has(feature.properties.id)).forEach((feature) => {
        const properties = feature.properties;
        const label = state.lang === "zh" ? properties.zh : properties.en;
        L.marker([properties.labelLat, properties.labelLng], {
          interactive: false,
          icon: L.divIcon({className: "p124-map-label", html: escapeHtml(label), iconSize: null})
        }).addTo(state.answerLabelLayer);
      });
      state.answerLabelLayer.addTo(map);
      ui.legendWrongItem.hidden = wrongIds.size === 0;
      ui.mapPanel.hidden = false;
      const focus = {
        type: "FeatureCollection",
        features: data.features.filter((feature) => focusIds.has(feature.properties.id))
      };
      requestAnimationFrame(() => {
        map.invalidateSize();
        const bounds = L.geoJSON(focus).getBounds();
        if (bounds.isValid()) map.fitBounds(bounds, {padding: [22, 22], maxZoom: 6});
        ui.mapPanel.scrollIntoView({behavior: "smooth", block: "nearest"});
      });
    } catch (error) {
      hideAnswerMap();
      console.warn("P124 answer map could not be displayed.", error);
    }
  }

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
    hideAnswerMap();
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
    hideAnswerMap();
    renderAnswers();
    renderCandidates();
  }

  function removeAnswer(id) {
    state.selected = state.selected.filter((value) => value !== id);
    state.checked = false;
    ui.feedback.className = "feedback";
    ui.feedback.textContent = "";
    hideAnswerMap();
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
    renderAnswerMap();
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
    ui.mapKicker.textContent = t.mapKicker;
    ui.mapHeading.textContent = t.mapHeading;
    ui.legendTarget.textContent = t.mapTarget;
    ui.legendCorrect.textContent = t.mapCorrect;
    ui.legendWrong.textContent = t.mapWrong;
    const source = mapSources[state.category?.CategoryCode];
    if (source) {
      ui.mapSource.innerHTML = `<a href="${source.url}" target="_blank" rel="noopener">${escapeHtml(source[state.lang])}</a>`;
    } else {
      ui.mapSource.textContent = "";
    }
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
      if (state.checked) renderAnswerMap();
    });
    ui.submit.addEventListener("click", checkAnswer);
    ui.reset.addEventListener("click", () => {
      state.selected = [];
      state.checked = false;
      ui.feedback.className = "feedback";
      ui.feedback.textContent = "";
      hideAnswerMap();
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
