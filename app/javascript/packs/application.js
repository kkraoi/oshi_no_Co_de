import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "./posts"
import "../styles/markdown"

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
});