export default class InterviewGacha {
  constructor() {
    this.root = document.getElementById("js-interview-gacha")
    if (!this.root) return;
    
    this.gachaBtn = document.getElementById("js-gacha-btn");
    this.resultEl = document.getElementById("js-gacha-result");
    this.templateQusetionEl = document.getElementById("js-gacha-template-question");
    this.templatePrevEl = document.getElementById("js-gacha-template-prev");
    this.templateNextEl = document.getElementById("js-gacha-template-next");
    this.paginations = document.getElementById("js-gacha-paginations");

    this.CURRENT_CLASS_NAME = "current"

    this.gachaData = [];
    this.currentIndex = 0;

    this.setupEventListeners();
  }

  setupEventListeners() {
    this.gachaBtn?.addEventListener("click", (self) => {
      this.drawGacha(self);
      self.target.textContent = `10連リセット`
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
      this.setupPagination();
    })
    .catch(() => console.error("エラーが発生しました"))
  }

  setupQuestions() {
    this.resultEl.innerHTML = "";

    this.gachaData.forEach((interview, i) => {
      const clone = this.templateQusetionEl.content.cloneNode(true);

      const questionBoxEl = clone.querySelector(".js-gacha-question-box");
      questionBoxEl.dataset.index = i;
      questionBoxEl.style.cursor= "pointer";
      questionBoxEl.addEventListener("click", this.showNext.bind(this));

      const questionEl = clone.querySelector(".js-gacha-question");
      questionEl.textContent = interview.content;

      const difficultBtnEl = clone.querySelector(".js-gacha-difficult");
      difficultBtnEl?.addEventListener("click", () => {
        // TODO
        console.log("苦手ボタンを押した");
      });

      this.resultEl.appendChild(clone);
    });
  }

  setupCurrentQuestion() {
    const currentQuestionBoxEl = this.resultEl.querySelector(`.js-gacha-question-box[data-index="${this.currentIndex}"]`);
    currentQuestionBoxEl.classList.add(this.CURRENT_CLASS_NAME);
    return currentQuestionBoxEl;
  }

  setupBtn(template, method) {
    const clone  = template.content.cloneNode(true);
    const btn = clone.querySelector("button");
    // .bind(this) : addEventListenerとしてのthisが適用されてしまうが、bindメソッドにthisに対応するものを引数に指定すると、thisはその引数のものとして扱うことができる。
    btn?.addEventListener("click", method.bind(this));
    this.resultEl.appendChild(clone);
  }

  changeQuestion() {
    this.resultEl.querySelectorAll(".js-gacha-question-box").forEach(box => box.classList.remove(this.CURRENT_CLASS_NAME));
    this.resultEl.querySelector(`.js-gacha-question-box[data-index="${this.currentIndex}"]`).classList.add(this.CURRENT_CLASS_NAME);

    if (this.paginations) {
      this.paginations.querySelectorAll(".gacha-pagination-btn").forEach(btn => btn.classList.remove(this.CURRENT_CLASS_NAME));
      this.paginations.querySelector(`.gacha-pagination-btn[data-index="${this.currentIndex}"]`).classList.add(this.CURRENT_CLASS_NAME);
    }
  }

  showPrev() {
    const len = this.gachaData.length;
    this.currentIndex = (this.currentIndex - 1 + len) % len;
    this.changeQuestion();
  }

  showNext() {
    const len = this.gachaData.length;
    this.currentIndex = (this.currentIndex + 1) % len;
    this.changeQuestion();
  }

  setupPagination() {
    this.paginations.innerHTML = "";

    for (let i = 0; i < this.gachaData.length; i++) {
      const btn = document.createElement("button");
      btn.addEventListener("click", () => {
        this.currentIndex = i;
        this.changeQuestion();
      })
      btn.classList.add("gacha-pagination-btn");
      btn.dataset.index = i;
      if(this.currentIndex == i) btn.classList.add(this.CURRENT_CLASS_NAME);
      this.paginations?.appendChild(btn)
    }
  }
}