// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

/**
 * ヘッダーにアクティブクラスをつけ外しする
 * @returns {void}
 */
function setupHeader() {
  const header = document.getElementById("js-header")
  const trigger = document.getElementById("js-nav-trigger")
  if (!header || !trigger) return;

  const ACTIVE_CLASS_NAME = "is-active"

  trigger.addEventListener("click", () => {
    header.classList.toggle(ACTIVE_CLASS_NAME)
  })
}

function setupScrollToTop() {
  const trigger = document.getElementById("js-to-top")
  if(!trigger) return;

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
});