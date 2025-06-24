// 管理側通報フィードバックで使用するラジオボタンの処理

document.addEventListener("turbolinks:load", () => {
  const raidowrap = document.getElementById("js-raidowrap-feedback");
  const adminFeedback = document.getElementById("js-admin_feedback");
  if (!raidowrap || !adminFeedback) return;

  const radiobtns = raidowrap.querySelectorAll('input[name="hide_comment"]');
  const messages = {
    true: "コメントを非表示にいたします。",
    false: "問題のないコメントと判断いたしましたため、コメントを残します。"
  };

  radiobtns.forEach(radiobtn => {
    radiobtn.addEventListener("click", (e) => {
      const val = e.target.value;
      adminFeedback.value = messages[val]
    });
  });
});