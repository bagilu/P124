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
    legendWrongItem: $("#legendWrongItem"), mapSource: $("#mapSource"),
    challengeCount: $("#challengeCountSelect"), challengeCountLabel: $("#challengeCountLabel"),
    startChallenge: $("#startChallengeButton"), settings: $("#challengeSettings"),
    settingsLabel: $("#settingsLabel"), settingsHint: $("#settingsHint"),
    scoreRegionLabel: $("#scoreRegionLabel"), scoreRegion: $("#scoreRegion"),
    scoreProgressLabel: $("#scoreProgressLabel"), scoreProgress: $("#scoreProgress"),
    scoreTotalLabel: $("#scoreTotalLabel"), scoreTotal: $("#scoreTotal"),
    scoreStreakLabel: $("#scoreStreakLabel"), scoreStreak: $("#scoreStreak"),
    scoreBestLabel: $("#scoreBestLabel"), scoreBest: $("#scoreBest"),
    result: $("#challengeResult"), resultKicker: $("#resultKicker"), resultHeading: $("#resultHeading"),
    resultScore: $("#resultScore"), resultMaximum: $("#resultMaximum"), resultRegion: $("#resultRegion"),
    resultQuestionsLabel: $("#resultQuestionsLabel"), resultQuestions: $("#resultQuestions"),
    resultPerfectLabel: $("#resultPerfectLabel"), resultPerfect: $("#resultPerfect"),
    resultStreakLabel: $("#resultStreakLabel"), resultStreak: $("#resultStreak"),
    resultBestLabel: $("#resultBestLabel"), resultBest: $("#resultBest"),
    resultRecord: $("#resultRecord"), retryChallenge: $("#retryChallengeButton"),
    changeChallenge: $("#changeChallengeButton")
  };

  const state = {
    lang: localStorage.getItem("P124LanguageV06") || "en",
    categories: [], questions: [], category: null, question: null, candidates: [], selected: [],
    checked: false, source: "demo", questionIndex: 0,
    geoData: new Map(), answerMap: null, answerMapLayer: null, answerLabelLayer: null, mapRequest: 0,
    challenge: {
      active: false, finished: false, targetCount: 10, answeredCount: 0, totalScore: 0,
      perfectCount: 0, currentStreak: 0, bestStreak: 0, questionQueue: [],
      scoredCurrent: false, currentQuestionScore: null, lastQuestionID: null, newBest: false
    }
  };

  const mapFiles = {
    CN_PROVINCES: "geo/CN_PROVINCES.geojson",
    TW_COUNTIES: "geo/TW_COUNTIES.geojson",
    US_STATES: "geo/US_STATES.geojson",
    EUROPE_COUNTRIES: "geo/EUROPE_COUNTRIES.geojson",
    AFRICA_COUNTRIES: "geo/AFRICA_COUNTRIES.geojson",
    ASIA_COUNTRIES: "geo/ASIA_COUNTRIES.geojson",
    SOUTH_AMERICA_COUNTRIES: "geo/SOUTH_AMERICA_COUNTRIES.geojson",
    NORTH_CENTRAL_CARIBBEAN_COUNTRIES: "geo/NORTH_CENTRAL_CARIBBEAN_COUNTRIES.geojson"
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
    },
    US_STATES: {
      zh: "邊界資料：Natural Earth（已簡化）",
      en: "Boundary data: Natural Earth (simplified)",
      url: "https://www.naturalearthdata.com/"
    },
    EUROPE_COUNTRIES: {
      zh: "邊界資料：Natural Earth（已簡化）",
      en: "Boundary data: Natural Earth (simplified)",
      url: "https://www.naturalearthdata.com/"
    },
    AFRICA_COUNTRIES: {
      zh: "邊界資料：Natural Earth（已簡化）",
      en: "Boundary data: Natural Earth (simplified)",
      url: "https://www.naturalearthdata.com/"
    },
    ASIA_COUNTRIES: {
      zh: "邊界資料：Natural Earth（已簡化）",
      en: "Boundary data: Natural Earth (simplified)",
      url: "https://www.naturalearthdata.com/"
    },
    SOUTH_AMERICA_COUNTRIES: {
      zh: "邊界資料：Natural Earth（已簡化）",
      en: "Boundary data: Natural Earth (simplified)",
      url: "https://www.naturalearthdata.com/"
    },
    NORTH_CENTRAL_CARIBBEAN_COUNTRIES: {
      zh: "邊界資料：Natural Earth（已簡化）",
      en: "Boundary data: Natural Earth (simplified)",
      url: "https://www.naturalearthdata.com/"
    }
  };

  const copy = {
    zh: {
      sourceDemo: "示範資料", sourceDb: "Supabase資料", eyebrow: "地理接壤挑戰",
      heading: "選出所有相鄰地區", category: "題目分類", candidateKicker: "候選區",
      candidateHeading: "點選或拖曳答案", target: "題目", hint: "與哪些地區接壤？",
      drop: "拖曳至此", selected: (n) => `已選 ${n}`, choices: (n) => `尚有 ${n} 個候選`,
      reset: "清除本題選擇", submit: "提交答案", next: "下一題", results: "查看結果",
      instruction: "每題僅第一次提交計分；提交後仍可修正答案並查看地圖，但不會重新計分。",
      empty: "請先選擇至少一個答案。",
      firstSuccess: (score) => `完全正確！本題獲得 ${score} 分。`,
      firstError: (score, w, m) => `本題獲得 ${score} 分：選錯 ${w} 個，遺漏 ${m} 個。可以修正答案，但分數不會變更。`,
      retrySuccess: (score) => `現在完全正確；本題首次提交得分仍為 ${score} 分。`,
      retryError: (score, w, m) => `本題首次提交得分為 ${score} 分；目前選錯 ${w} 個，遺漏 ${m} 個。`,
      noQuestion: "這個分類目前沒有可用題目。", switchLabel: "Switch to English",
      question: (n) => `題目 ${String(n).padStart(2, "0")}`,
      mapKicker: "答案地圖", mapHeading: "正確的相鄰地區", mapTarget: "題目地區",
      mapCorrect: "正確鄰居", mapWrong: "誤選地區",
      challengeLength: "挑戰題數", fiveQuestions: "5題", tenQuestions: "10題", twentyQuestions: "20題",
      settings: "挑戰設定", settingsHint: (region, count) => `${region} · ${count}題`,
      startChallenge: "開始挑戰", restartChallenge: "重新開始挑戰",
      confirmRestart: "目前的挑戰尚未完成。確定要重新開始嗎？",
      ready: "請選擇區域與挑戰題數，然後按下「開始挑戰」。",
      readyTarget: "準備挑戰", region: "區域", progress: "累計題數", score: "累計分數",
      streak: "連勝", localBest: "本機最高分", noBest: "尚無",
      challengeComplete: "挑戰完成", yourResult: "本次挑戰結果",
      resultQuestions: "題數", resultPerfect: "完全正確", resultBestStreak: "最佳連勝",
      newBest: "創下本機新紀錄", tryAgain: "再挑戰一次", changeChallenge: "更換挑戰",
      needSubmit: "請先提交本題答案，才能進入下一題。"
    },
    en: {
      sourceDemo: "Demo data", sourceDb: "Supabase data", eyebrow: "Geographic Border Challenge",
      heading: "Find every bordering region", category: "Question category", candidateKicker: "Candidates",
      candidateHeading: "Tap or drag an answer", target: "QUESTION", hint: "Which regions share a border?",
      drop: "DROP HERE", selected: (n) => `${n} selected`, choices: (n) => `${n} choices remain`,
      reset: "Clear selection", submit: "Check answer", next: "Next question", results: "View results",
      instruction: "Only the first submission scores. You may revise answers and view the map afterward, but the score will not change.",
      empty: "Select at least one answer first.",
      firstSuccess: (score) => `Exactly right! You earned ${score} points.`,
      firstError: (score, w, m) => `You earned ${score} points: ${w} incorrect and ${m} missing. You may revise the answer, but the score is final.`,
      retrySuccess: (score) => `Now completely correct. Your first-submission score remains ${score}.`,
      retryError: (score, w, m) => `Your first-submission score is ${score}; currently ${w} incorrect and ${m} missing.`,
      noQuestion: "There are no available questions in this category.", switchLabel: "切換為中文",
      question: (n) => `QUESTION ${String(n).padStart(2, "0")}`,
      mapKicker: "ANSWER MAP", mapHeading: "The correct bordering regions", mapTarget: "Target",
      mapCorrect: "Correct neighbors", mapWrong: "Incorrect choices",
      challengeLength: "Challenge length", fiveQuestions: "5 questions", tenQuestions: "10 questions", twentyQuestions: "20 questions",
      settings: "CHALLENGE SETTINGS", settingsHint: (region, count) => `${region} · ${count} questions`,
      startChallenge: "Start challenge", restartChallenge: "Restart challenge",
      confirmRestart: "This challenge is still in progress. Restart it?",
      ready: "Choose a region and challenge length, then select “Start challenge.”",
      readyTarget: "READY", region: "REGION", progress: "PROGRESS", score: "SCORE",
      streak: "STREAK", localBest: "LOCAL BEST", noBest: "None",
      challengeComplete: "CHALLENGE COMPLETE", yourResult: "Your result",
      resultQuestions: "QUESTIONS", resultPerfect: "PERFECT", resultBestStreak: "BEST STREAK",
      newBest: "NEW LOCAL BEST", tryAgain: "Try again", changeChallenge: "Change challenge",
      needSubmit: "Submit this answer before moving to the next question."
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
  function categoryName() {
    if (!state.category) return "—";
    return state.lang === "zh" ? state.category.CategoryNameZh : state.category.CategoryNameEn;
  }

  function bestScoreKey() {
    return `P124ChallengeBestV08:${state.category?.CategoryCode || "NONE"}:${state.challenge.targetCount}`;
  }

  function readLocalBest() {
    try {
      const value = JSON.parse(localStorage.getItem(bestScoreKey()) || "null");
      return value && Number.isFinite(Number(value.score)) ? value : null;
    } catch (error) {
      return null;
    }
  }

  function writeLocalBest(result) {
    try {
      localStorage.setItem(bestScoreKey(), JSON.stringify(result));
    } catch (error) {
      console.warn("P124 could not save the local best score.", error);
    }
  }

  function calculateQuestionScore(correctIDs, selectedIDs) {
    const correct = new Set(correctIDs);
    const selected = new Set(selectedIDs);
    const hits = [...selected].filter((id) => correct.has(id)).length;
    const wrong = [...selected].filter((id) => !correct.has(id)).length;
    const missing = [...correct].filter((id) => !selected.has(id)).length;
    const denominator = (2 * hits) + wrong + missing;
    return denominator ? Math.round(100 * (2 * hits) / denominator) : 0;
  }

  function availableQuestions() {
    return state.questions.filter(
      (question) => Number(question.CategoryID) === Number(state.category?.CategoryID) && question.IsActive !== false
    );
  }

  function refillQuestionQueue() {
    const pool = shuffle(availableQuestions());
    if (pool.length > 1 && pool[0].QuestionID === state.challenge.lastQuestionID) {
      [pool[0], pool[1]] = [pool[1], pool[0]];
    }
    state.challenge.questionQueue = pool;
  }

  function setChallengeControlsLocked(locked) {
    ui.category.disabled = locked;
    ui.challengeCount.disabled = locked;
  }

  function renderScoreboard() {
    const t = copy[state.lang];
    const best = readLocalBest();
    ui.scoreRegionLabel.textContent = t.region;
    ui.scoreProgressLabel.textContent = t.progress;
    ui.scoreTotalLabel.textContent = t.score;
    ui.scoreStreakLabel.textContent = t.streak;
    ui.scoreBestLabel.textContent = t.localBest;
    ui.scoreRegion.textContent = categoryName();
    ui.scoreProgress.textContent = `${state.challenge.answeredCount} / ${state.challenge.targetCount}`;
    ui.scoreTotal.textContent = String(state.challenge.totalScore);
    ui.scoreStreak.textContent = `× ${state.challenge.currentStreak}`;
    ui.scoreBest.textContent = best ? String(best.score) : t.noBest;
  }

  function renderResultCard() {
    const t = copy[state.lang];
    const best = readLocalBest();
    ui.resultKicker.textContent = t.challengeComplete;
    ui.resultHeading.textContent = t.yourResult;
    ui.resultScore.textContent = String(state.challenge.totalScore);
    ui.resultMaximum.textContent = `/ ${state.challenge.targetCount * 100}`;
    ui.resultRegion.textContent = categoryName();
    ui.resultQuestionsLabel.textContent = t.resultQuestions;
    ui.resultPerfectLabel.textContent = t.resultPerfect;
    ui.resultStreakLabel.textContent = t.resultBestStreak;
    ui.resultBestLabel.textContent = t.localBest;
    ui.resultQuestions.textContent = String(state.challenge.targetCount);
    ui.resultPerfect.textContent = String(state.challenge.perfectCount);
    ui.resultStreak.textContent = String(state.challenge.bestStreak);
    ui.resultBest.textContent = String(best?.score ?? state.challenge.totalScore);
    ui.resultRecord.textContent = t.newBest;
    ui.resultRecord.hidden = !state.challenge.newBest;
    ui.retryChallenge.textContent = t.tryAgain;
    ui.changeChallenge.textContent = t.changeChallenge;
  }

  function showChallengeSetup() {
    state.challenge.active = false;
    state.challenge.finished = false;
    state.challenge.answeredCount = 0;
    state.challenge.totalScore = 0;
    state.challenge.perfectCount = 0;
    state.challenge.currentStreak = 0;
    state.challenge.bestStreak = 0;
    state.challenge.questionQueue = [];
    state.challenge.scoredCurrent = false;
    state.challenge.currentQuestionScore = null;
    state.challenge.lastQuestionID = null;
    state.challenge.newBest = false;
    state.challenge.targetCount = Number(ui.challengeCount.value || 10);
    state.question = null;
    state.candidates = [];
    state.selected = [];
    state.checked = false;
    state.questionIndex = 0;
    ui.result.hidden = true;
    setChallengeControlsLocked(false);
    ui.settings.open = true;
    hideAnswerMap();
    render();
  }

  function startChallenge(force = false) {
    const t = copy[state.lang];
    if (!force && state.challenge.active && !window.confirm(t.confirmRestart)) return;
    state.challenge.active = true;
    state.challenge.finished = false;
    state.challenge.targetCount = Number(ui.challengeCount.value || 10);
    state.challenge.answeredCount = 0;
    state.challenge.totalScore = 0;
    state.challenge.perfectCount = 0;
    state.challenge.currentStreak = 0;
    state.challenge.bestStreak = 0;
    state.challenge.questionQueue = [];
    state.challenge.scoredCurrent = false;
    state.challenge.currentQuestionScore = null;
    state.challenge.lastQuestionID = null;
    state.challenge.newBest = false;
    state.questionIndex = 0;
    ui.result.hidden = true;
    setChallengeControlsLocked(true);
    ui.settings.open = false;
    nextChallengeQuestion(true);
  }

  function nextChallengeQuestion(force = false) {
    const t = copy[state.lang];
    if (!state.challenge.active) return;
    if (!force && state.question && !state.challenge.scoredCurrent) {
      ui.feedback.className = "feedback error";
      ui.feedback.textContent = t.needSubmit;
      return;
    }
    if (state.challenge.answeredCount >= state.challenge.targetCount) {
      finishChallenge();
      return;
    }
    if (!state.challenge.questionQueue.length) refillQuestionQueue();
    const question = state.challenge.questionQueue.shift();
    if (!question) {
      state.challenge.active = false;
      state.question = null;
      setChallengeControlsLocked(false);
      render();
      return;
    }
    state.challenge.lastQuestionID = question.QuestionID;
    state.questionIndex = state.challenge.answeredCount + 1;
    setQuestion(question);
  }

  function finishChallenge() {
    const priorBest = readLocalBest();
    state.challenge.active = false;
    state.challenge.finished = true;
    state.challenge.newBest = !priorBest || state.challenge.totalScore > Number(priorBest.score);
    if (state.challenge.newBest) {
      writeLocalBest({
        score: state.challenge.totalScore,
        perfectCount: state.challenge.perfectCount,
        bestStreak: state.challenge.bestStreak,
        completedAt: new Date().toISOString()
      });
    }
    setChallengeControlsLocked(false);
    render();
    renderResultCard();
    ui.result.hidden = false;
    requestAnimationFrame(() => ui.result.scrollIntoView({behavior: "smooth", block: "center"}));
  }

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
      const names = itemMap();
      data.features.filter((feature) => labeledIds.has(feature.properties.id)).forEach((feature) => {
        const properties = feature.properties;
        const catalogItem = names.get(properties.id);
        const label = catalogItem ? nameFor(catalogItem) : (state.lang === "zh" ? properties.zh : properties.en);
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
    const randomPool = shuffle(category.Items.map((item) => item.id).filter((id) => !blocked.has(id) && !id.endsWith("-NONE")));
    const general = randomPool.slice(0, Math.max(0, requestedTotal - minimumTotal));
    return shuffle([...correct, ...preferred, ...general]);
  }

  function setQuestion(question) {
    hideAnswerMap();
    state.question = question;
    state.selected = [];
    state.checked = false;
    state.challenge.scoredCurrent = false;
    state.challenge.currentQuestionScore = null;
    state.candidates = buildCandidates(question, state.category);
    ui.feedback.className = "feedback";
    ui.feedback.textContent = "";
    render();
  }

  function addAnswer(id) {
    if (!state.challenge.active || !state.question || state.selected.includes(id)) return;
    state.selected.push(id);
    state.checked = false;
    ui.feedback.className = "feedback";
    ui.feedback.textContent = "";
    hideAnswerMap();
    renderAnswers();
    renderCandidates();
  }

  function removeAnswer(id) {
    if (!state.challenge.active) return;
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
    if (!state.challenge.active || !state.question) return;
    if (!state.selected.length) {
      ui.feedback.className = "feedback error";
      ui.feedback.textContent = t.empty;
      return;
    }
    state.checked = true;
    const correct = new Set(state.question.CorrectItemIDs);
    const wrong = state.selected.filter((id) => !correct.has(id));
    const missing = state.question.CorrectItemIDs.filter((id) => !state.selected.includes(id));
    const isPerfect = !wrong.length && !missing.length;
    if (!state.challenge.scoredCurrent) {
      const score = calculateQuestionScore(state.question.CorrectItemIDs, state.selected);
      state.challenge.scoredCurrent = true;
      state.challenge.currentQuestionScore = score;
      state.challenge.answeredCount += 1;
      state.challenge.totalScore += score;
      if (isPerfect) {
        state.challenge.perfectCount += 1;
        state.challenge.currentStreak += 1;
        state.challenge.bestStreak = Math.max(state.challenge.bestStreak, state.challenge.currentStreak);
      } else {
        state.challenge.currentStreak = 0;
      }
      ui.feedback.className = isPerfect ? "feedback success" : "feedback error";
      ui.feedback.textContent = isPerfect
        ? t.firstSuccess(score)
        : t.firstError(score, wrong.length, missing.length);
    } else if (isPerfect) {
      ui.feedback.className = "feedback success";
      ui.feedback.textContent = t.retrySuccess(state.challenge.currentQuestionScore);
    } else {
      ui.feedback.className = "feedback error";
      ui.feedback.textContent = t.retryError(state.challenge.currentQuestionScore, wrong.length, missing.length);
    }
    renderAnswers();
    renderCandidates();
    renderScoreboard();
    ui.next.disabled = false;
    ui.next.textContent = state.challenge.answeredCount >= state.challenge.targetCount ? t.results : t.next;
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
    if (!state.question) {
      ui.rail.innerHTML = "";
      ui.candidateCount.textContent = copy[state.lang].choices(0);
      return;
    }
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
    if (!state.question) {
      ui.selectedLayer.innerHTML = "";
      ui.selectionCount.textContent = copy[state.lang].selected(0);
      return;
    }
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
    $("#gameHeading").textContent = t.heading;
    ui.settingsLabel.textContent = t.settings;
    ui.settingsHint.textContent = t.settingsHint(categoryName(), state.challenge.targetCount);
    $("#categoryLabel").textContent = t.category;
    ui.challengeCountLabel.textContent = t.challengeLength;
    ui.challengeCount.options[0].textContent = t.fiveQuestions;
    ui.challengeCount.options[1].textContent = t.tenQuestions;
    ui.challengeCount.options[2].textContent = t.twentyQuestions;
    ui.startChallenge.textContent = state.challenge.active ? t.restartChallenge : t.startChallenge;
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
    document.body.classList.toggle("challenge-active", state.challenge.active);
    document.body.classList.toggle("challenge-finished", state.challenge.finished);
    renderStaticCopy();
    renderCategoryOptions();
    renderScoreboard();
    const t = copy[state.lang];
    if (!state.question) {
      const hasQuestions = availableQuestions().length > 0;
      ui.targetName.textContent = hasQuestions ? t.readyTarget : "—";
      ui.questionNumber.textContent = t.question(0);
      ui.feedback.className = "feedback";
      ui.feedback.textContent = hasQuestions ? t.ready : t.noQuestion;
      renderCandidates();
      renderAnswers();
      ui.reset.disabled = true;
      ui.submit.disabled = true;
      ui.next.disabled = true;
      return;
    }
    const target = itemMap().get(state.question.TargetItemID);
    ui.targetName.textContent = target ? nameFor(target) : state.question.TargetItemID;
    ui.questionNumber.textContent = t.question(state.questionIndex);
    ui.reset.disabled = !state.challenge.active;
    ui.submit.disabled = !state.challenge.active;
    ui.next.disabled = !state.challenge.active || !state.challenge.scoredCurrent;
    ui.next.textContent = state.challenge.scoredCurrent && state.challenge.answeredCount >= state.challenge.targetCount
      ? t.results
      : t.next;
    renderCandidates();
    renderAnswers();
    if (state.challenge.finished) renderResultCard();
  }

  function bindEvents() {
    ui.category.addEventListener("change", () => {
      state.category = state.categories.find((item) => Number(item.CategoryID) === Number(ui.category.value));
      showChallengeSetup();
    });
    ui.challengeCount.addEventListener("change", () => {
      state.challenge.targetCount = Number(ui.challengeCount.value || 10);
      renderScoreboard();
    });
    ui.startChallenge.addEventListener("click", () => startChallenge(false));
    ui.language.addEventListener("click", () => {
      state.lang = state.lang === "zh" ? "en" : "zh";
      localStorage.setItem("P124LanguageV06", state.lang);
      render();
      if (state.checked) renderAnswerMap();
    });
    ui.submit.addEventListener("click", checkAnswer);
    ui.reset.addEventListener("click", () => {
      if (!state.challenge.active || !state.question) return;
      state.selected = [];
      state.checked = false;
      ui.feedback.className = "feedback";
      ui.feedback.textContent = "";
      hideAnswerMap();
      renderAnswers();
      renderCandidates();
    });
    ui.next.addEventListener("click", () => nextChallengeQuestion(false));
    ui.retryChallenge.addEventListener("click", () => startChallenge(true));
    ui.changeChallenge.addEventListener("click", showChallengeSetup);
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
    state.categories = data.categories
      .map(normalizeCategory)
      .filter((item) => item.IsActive !== false)
      .sort((a, b) => Number(a.SortOrder || 0) - Number(b.SortOrder || 0));
    state.questions = data.questions.map(normalizeQuestion).filter((item) => item.IsActive !== false);
    state.category = state.categories[0] || null;
    showChallengeSetup();
  }

  init();
})();
