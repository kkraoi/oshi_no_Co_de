import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

/**
 * デバイス判定
 *
 * @param {String: 'pc' or 'sp'} device
 * @return {boolean}
 */
const mq = (device) => (window.matchMedia("(min-width:768px)").matches ? device === "pc" : device === "sp");

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
          // トースター活性の記述
          console.log("コードをコピーしました");
        }).catch((err) => {
          console.error("コピーに失敗しました", err)
        });
      });
    }
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
});