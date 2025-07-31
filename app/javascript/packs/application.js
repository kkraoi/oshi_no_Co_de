import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "./changeRaidoForReport"

// トースターを閉じるクラス
const G_CLOSE_TOAST_CLASS_NAME = "is-close";

/**
 * デバイス判定
 *
 * @param {String: 'pc' or 'sp'} device
 * @return {boolean}
 */
const mq = (device) => (window.matchMedia("(min-width:768px)").matches ? device === "pc" : device === "sp");

/**
 * トースト通知を表示させる
 * 
 * @param {string} message - 表示させるメッセージ。絵文字✅🤨付きを推奨。
 * @param {boolean} isAlert - アラート版にしたい場合true
 * @param {number} mseconds - 表示させる時間（m秒）
 * @returns {void}
 */
function showToast(message, isAlert = false, mseconds = 4000) {
  const toast = document.getElementById("js-toast-1");
  if(!toast) return;

  const messageElm = toast.querySelector(".js-toast-message");
  if(messageElm === null) return;

  const ALERT_CLASS_NAME = "is-alert";

  messageElm.innerText = message;

  if (isAlert) {
    toast.classList.add(ALERT_CLASS_NAME);
  }

  toast.classList.remove(G_CLOSE_TOAST_CLASS_NAME);

  setTimeout(() => {
    toast.classList.add(G_CLOSE_TOAST_CLASS_NAME);
    toast.classList.remove(ALERT_CLASS_NAME);
  }, mseconds);
}

/**
 * トースターを閉じるボタンをセット
 * @returns {void}
 */
function setupCloseToastBtn() {
  const closeBtns = document.querySelectorAll(".js-toast-close");
  if (closeBtns.length === 0) return;

  closeBtns.forEach((btn) => {
    const toast = btn.closest(".js-toast");
    if (toast) {
      btn.addEventListener("click", () => {
        toast.classList.add(G_CLOSE_TOAST_CLASS_NAME)
      });
    };
  });
}

function setupToast() {
  const toast = document.getElementById("js-toast");
  if (!toast) return;
  setTimeout(() => {
    toast.classList.add(G_CLOSE_TOAST_CLASS_NAME)
  }, 4000)
}

/**
 * ヘッダーにアクティブクラスをつけ外しする
 * @returns {void}
 */
function setupHeader() {
  const header = document.getElementById("js-header");
  const trigger = document.getElementById("js-nav-trigger");
  if (!header || !trigger) return;

  const ACTIVE_CLASS_NAME = "is-active";

  trigger.addEventListener("click", () => {
    header.classList.toggle(ACTIVE_CLASS_NAME);
  });
}

/**
 * サイドメニューを開閉する処理
 * @returns {void}
 */
function setupDrawSideMenu() {
  const root = document.getElementById("js-col2-root");
  const trigger = document.getElementById("js-col2-drawer");
  if (!root || !trigger) return;

  const CLOSE_CLASS_NAME = "is-close";

  if(mq("sp")) {
    root.classList.add(CLOSE_CLASS_NAME)
  }

  trigger.addEventListener("click", () => {
    root.classList.toggle(CLOSE_CLASS_NAME);
  });
}

/**
 * トップ位置にスクロールする処理
 * @returns {void}
 */
function setupScrollToTop() {
  const trigger = document.getElementById("js-to-top");
  if (!trigger) return;

  trigger.addEventListener("click", () => {
    window.scrollTo({
      top: 0,
      behavior: "smooth"
    });
  });
}

/**
 * preタグ内のコードをコピーする。
 * @returns {void}
 */
function setupCopyCode() {
  const codes = document.querySelectorAll(".js-code");
  if (codes.length === 0) return;

  codes.forEach((code) => {
    const button = code.querySelector(".js-code-copy_btn");
    const pre = code.querySelector(".js-code-pre");
    if (button && pre) {
      button.addEventListener("click", () => {
        const text = pre.innerText;
        navigator.clipboard.writeText(text).then(() => {
          showToast("✅ コードをコピーしました", false, 1000)
        }).catch((err) => {
          showToast("🤨 コピーに失敗しました", true, 1000)
          console.error("コピーに失敗しました", err);
        });
      });
    }
  });
}

/**
 * ページ内遷移がターボリンクスの影響により、フォームがリセットされるのを防ぐことを目的として作った
 * @returns {void}
 */
function setupJump() {
  const triggers = document.querySelectorAll('.js-jump[href^="#"]');
  if (triggers.length === 0) return
  triggers.forEach((trigger) => {
    trigger.addEventListener("click", (e) => {
      e.preventDefault();
      const href = trigger.getAttribute("href");
      const targetID = href.slice(1);
      const target = document.getElementById(targetID);
      if (target) {
        window.scrollTo({
          top: target.getBoundingClientRect().top + window.pageYOffset,
          behavior: "smooth"
        });
      };
    });
  });
}

/**
 * タブメニューをセット
 * @returns {void}
 */
function setupTab() {
  const tabs = document.querySelectorAll(".js-tab");
  if (tabs.length === 0) return;
  
  tabs.forEach((tab) => {
    const triggers = tab.querySelectorAll(".js-tab-trigger");
    const contents = tab.querySelectorAll(".js-tab-content");

    if (triggers.length > 0 || contents.length > 0) {
      const ACTIVE_CLASS_NAME = "is-active";
      triggers[0].classList.add(ACTIVE_CLASS_NAME);
      contents[0].classList.add(ACTIVE_CLASS_NAME);

      triggers.forEach((trigger, i) => {
        trigger.addEventListener("click", () => {
          triggers.forEach(t => t.classList.remove(ACTIVE_CLASS_NAME));
          contents.forEach(c => c.classList.remove(ACTIVE_CLASS_NAME));
          
          trigger.classList.add(ACTIVE_CLASS_NAME);
          contents[i].classList.add(ACTIVE_CLASS_NAME);
        });
      });
    };
  });
}

/**
 * チャットを最下部までスクロールさせる
 * @returns {void}
 */
function chatScrollBottom() {
  const chatWrap = document.getElementById("chat");
  if (!chatWrap) return;
  chatWrap.scrollTop = chatWrap.scrollHeight;
}

/**
 * ポップアップUIをセットする
 * @returns {void}
 */
function setupPopup() {
  const roots = document.querySelectorAll(".js-popup-root");
  const triggers = document.querySelectorAll(".js-popup-trigger");
  if(roots.length === 0 || triggers === 0) return;
  const ACTIVE_CLASS_NAME = "is-active";

  triggers.forEach((trigger) => {
    trigger.addEventListener("click", () => {
      const targetID = trigger.dataset.target;
      const targetRoot = document.getElementById(targetID);
      targetRoot.classList.add(ACTIVE_CLASS_NAME);
    });
  });

  roots.forEach((root) => {
    const closers = root.querySelectorAll('[class*="js-popup-close"]');
    if (closers.length > 0) {
      closers.forEach((closer) => {
        closer.addEventListener("click", () => {
          root.classList.remove(ACTIVE_CLASS_NAME);
        });
      });
    };
  });
}

/**
 * CodeMirrorライブラリをカスタマイズする
 * @returns {void}
 */
function setupCodeMirror() {
  const textareas = document.querySelectorAll("textarea.js-code-textarea");
  if(textareas.length === 0)return;
  const INITIALIZED_FLAG = "flag-cm-initialized";

  textareas.forEach(textarea => {
    if(!textarea.classList.contains(INITIALIZED_FLAG)){
      CodeMirror.fromTextArea(textarea, {
        lineNumbers: true,
        indentUnit: 2,
        tabSize: 2,
        indentWithTabs: false,
        extraKeys: {
          Tab: cm => cm.execCommand("indentMore"),
          "Shift-Tab": cm => cm.execCommand("indentLess")
        }
      });
    }
    textarea.classList.add(INITIALIZED_FLAG);
  });
}

/**
 * CodeMirrorの取得が遅れる場合があったため、ポーリングをかける
 * @param {number} 試行回数上限
 */
function pollingCodeMirror(retryCount = 10) {
  if (typeof CodeMirror === "undefined") {
    if (retryCount <= 0) return;
    setTimeout(() => pollingCodeMirror(retryCount - 1), 100);
    return;
  }
  setupCodeMirror();
}


/**
 * 動的にフォームのフィールドを追加・削除する
 * @param {function} afterAddedCallBack - フィールド追加後に実行する関数
 * @returns {void}
 */
function setupAddFields(afterAddedCallBack = () => {}) {
  const container = document.getElementById("js-fields-container");
  const template = document.getElementById("js-field-template");
  const addBtn = document.getElementById("js-add-field");
  if (!container || !template || !addBtn) return;

  // name="post[モデル_attributes][数字][属性名]" の「数字」に対応した番号
  let index = document.querySelectorAll(".js-field-block").length;

  const templateHTML = template.innerHTML;

  // フィールド追加処理
  addBtn.addEventListener("click", () => {
    const html = templateHTML.replace(/JS_INDEX/g, index);
    container.insertAdjacentHTML("beforeend", html);
    afterAddedCallBack()
    index++;
  });

  // フィールド削除処理
  container.addEventListener("click", (e) => {
    // イベントの伝播を利用して、js-remove-field要素の擬似押下を行う。
    // => フィールドを追加するたびに、js-remove-field要素にクリックイベントを仕込むと記述量が多くなってしまうから。
    const removeBtn = e.target.closest(".js-remove-field");
    if (removeBtn) {
      const block = e.target.closest(".js-field-block");
      const destroyInput = block.querySelector('input[name*="_destroy"]')
      if(destroyInput) {
        // accepts_nested_attributes_for :モデル, allow_destroy: trueにより、値が"1"になると削除する合図を送る
        destroyInput.value = "1"; 

        block.style.display = "none";
      } else {
        // 万が一 _destroy が存在しないときはDOMごと削除
        block.remove()
      };
    };
  });
}

/**
 * フォームをリセットする
 * @returns {void}
 */
function setupResetSortFilter(){
  const roots = document.querySelectorAll(".js-form-reset-root");
  if(roots.length === 0) return;

  const setDefaultRadio = (root) => {
    const defaultRadio = root.querySelector(".js-form-reset-radio-default")
    if (!defaultRadio) return
    defaultRadio.checked = true
  };

  roots.forEach((root) => {
    setDefaultRadio(root);

    const resetBtn = root.querySelector(".js-form-reset-btn");
    if(resetBtn) {
      resetBtn.addEventListener("click", () => {
        // チェックボックス・ラジオボタンのリセット
        const inputs = root.querySelectorAll("input[type='checkbox'], input[type='radio']");
        if (inputs) {
          inputs.forEach((input) => input.checked = false)
        }
        
        // 検索フィールドのリセット
        const searches = root.querySelectorAll("input[type='search']")
        if (searches) {
          searches.forEach((search) => search.value = "")
        }

        setDefaultRadio(root);
      });
    };
  });
}

function setupInterviewGacha() {

}

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// turbolinks:load <= ページ遷移後も発火するために使用
document.addEventListener("turbolinks:load", () => {
  setupHeader();
  setupScrollToTop();
  setupDrawSideMenu();
  setupCopyCode();
  setupCloseToastBtn();
  setupToast();
  setupJump();
  setupTab();
  chatScrollBottom()
  setupPopup()
  setupAddFields(setupCodeMirror)
  pollingCodeMirror();
  setupResetSortFilter();
  setupInterviewGacha();
});