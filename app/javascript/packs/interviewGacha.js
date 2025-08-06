export default class InterviewGacha {
  constructor() {
    this.root = document.getElementById("js-interview-gacha")
    if (!this.root) return;
    
    this.gachaBtn = document.getElementById("js-gacha-btn");
    this.resultEl = document.getElementById("js-gacha-result");
    this.templateQusetionEl = document.getElementById("js-gacha-template-question");
    this.templatePrevEl = document.getElementById("js-gacha-template-prev");
    this.templateNextEl = document.getElementById("js-gacha-template-next");

    this.gachaData = [];
    this.currentIndex = 0;

    this.setupEventListeners();
  }

  setupEventListeners() {
    this.gachaBtn?.addEventListener("click", (self) => {
      this.drawGacha(self);
      self.target.textContent = "10連リセット"
    });
  }

  drawGacha(self) {
    // 同一オリジンのurl: /users/5/interviews/draw_gacha.json など
    const { url } = self.currentTarget.dataset;

    fetch(url, {
      headers: {
        "X-CSRF-Token": document.querySelector(`meta[name="csrf-token"`).content
      },
      credentials: "same-origin"
    })
    .then(res => res.json())
    .then(data => {
      this.gachaData = data;
      this.currentIndex = 0;
      this.setupQuestions();
      this.setupCurrentQuestion();
      this.setupBtn(this.templatePrevEl, this.showPrev)
      this.setupBtn(this.templateNextEl, this.showNext)
    })
    .catch(() => console.error("エラーが発生しました"))
  }

  setupQuestions() {
    this.resultEl.innerHTML = "";

    this.gachaData.forEach((interview, i) => {
      const clone = this.templateQusetionEl.content.cloneNode(true);

      const questionBoxEl = clone.querySelector(".js-gacha-question-box");
      questionBoxEl.dataset.index = i;

      const questionEl = clone.querySelector(".js-gacha-question");
      questionEl.textContent = interview.content;

      const difficultBtnEl = clone.querySelector(".js-gacha-difficult");
      difficultBtnEl.addEventListener("click", () => {
        console.log("苦手ボタンを押した");
      });

      this.resultEl.appendChild(clone);
    });
  }

  setupCurrentQuestion() {
    const currentQuestionBoxEl = this.resultEl.querySelector(`.js-gacha-question-box[data-index="${this.currentIndex}"]`);
    const otherQuestionBoxEls = this.resultEl.querySelectorAll(`.js-gacha-question-box:not([data-index="${this.currentIndex}"])`);

    otherQuestionBoxEls.forEach(otherQ => {
      otherQ.style.display = "none";
    });

    currentQuestionBoxEl.style.display = "block";

    return currentQuestionBoxEl;
  }

  setupBtn(template, method) {
    const clone  = template.content.cloneNode(true);
    const btn = clone.querySelector("button")
    btn?.addEventListener("click", method);
    this.resultEl.appendChild(clone)
  }

  showPrev() {
    console.log("前の質問を提示")
  }

  showNext() {
    console.log("次の質問を提示")
  }
}