import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

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

function setupDrawSideMenu() {
  const root = document.getElementById("js-col2-root");
  const trigger = document.getElementById("js-col2-drawer");
  if (!root || !trigger) return;

  const ACTIVE_CLASS_NAME = "is-active";
  trigger.addEventListener("click", () => {
    root.classList.toggle(ACTIVE_CLASS_NAME);
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

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// turbolinks:load <= ページ遷移後も発火するために使用
document.addEventListener("turbolinks:load", () => {
  setupHeader();
  setupScrollToTop();
  setupDrawSideMenu();
});