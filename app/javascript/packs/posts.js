function setupAddCodeFields() {
  const container = document.getElementById("js-code-fields-container");
  const template = document.getElementById("js-code-field-template");
  const addBtn = document.getElementById("js-add-code-field");
  if (!container || !template || !addBtn) return;

  // name="post[codes_attributes][数字][属性名]" の「数字」に対応した番号
  let index = document.querySelectorAll(".js-code-block").length;

  const templateHTML = template.innerHTML;

  // フィールド追加処理
  addBtn.addEventListener("click", () => {
    const html = templateHTML.replace(/JS_INDEX/g, index);
    container.insertAdjacentHTML("beforeend", html);
    index++;
  });

  // フィールド削除処理
  container.addEventListener("click", (e) => {
    // イベントの伝播を利用して、js-remove-code-field要素の擬似押下を行う。
    // => フィールドを追加するたびに、js-remove-code-field要素にクリックイベントを仕込むと記述量が多くなってしまうから。
    const removeBtn = e.target.closest(".js-remove-code-field");
    if (removeBtn) {
      const block = e.target.closest(".js-code-block");
      const destroyInput = block.querySelector('input[name*="_destroy"]')
      if(destroyInput) {
        // accepts_nested_attributes_for :codes, allow_destroy: trueにより、値が"1"になると削除する合図を送る
        destroyInput.value = "1"; 

        block.style.display = "none";
      } else {
        // 万が一 _destroy が存在しないときはDOMごと削除
        block.remove()
      };
    };
  });
}

document.addEventListener("turbolinks:load", () => {
  // 投稿作成ページ以外は実行させない
  if (!document.body.classList.contains("js-posts-new")) return;
  setupAddCodeFields();
});