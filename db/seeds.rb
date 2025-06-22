# emailに一致するAdminを探し、なければ、新規作成として、ブロック内の処理をする。
Admin.find_or_create_by!(email: ENV["ADMIN_EMAIL"]) do |admin|
  # admin = Admin.new(email: ENV["ADMIN_EMAIL"]) <= これは、find_or_create_by! に引数で渡した値は、自動でカラムにセットされるので不要。
  
  # パスワードをセット
  admin.password = ENV["ADMIN_PASSWORD"]

  # パスワードの「確認用入力欄」と一致するかをチェックするにセット
  admin.password_confirmation = ENV["ADMIN_PASSWORD"]
end

# ActiveRecord::Base.transaction ↓
# ここでのデータベース操作は「全部成功」か「全部失敗」のどちらか
# 例: 1つでも失敗したら全てロールバック（取り消し）
ActiveRecord::Base.transaction do
  # 言語
  language_data = [
    # マークアップ言語
    { extension: 'html', name: 'HTML', color: "#B25F28" },
    { extension: 'htm',  name: 'HTML', color: "#B25F28" },
    { extension: 'xhtml', name: 'XHTML', color: "#AF5E28" },
    { extension: 'xml',  name: 'XML', color: "#B66129" },
    
    # スタイルシート
    { extension: 'css',  name: 'CSS', color: "#2965f1" },
    { extension: 'scss', name: 'Sass', color: "#AB3C5E" },
    { extension: 'sass', name: 'Sass', color: "#AB3C5E" },
    { extension: 'less', name: 'LESS', color: "#3F7790" },
    
    # プログラミング言語
    { extension: 'rb',   name: 'Ruby', color: "#A33236" },
    { extension: 'erb',  name: 'ERB', color: "#A33236" },
    { extension: 'js',   name: 'JavaScript', color: "#A2A234" },
    { extension: 'ts',   name: 'TypeScript', color: "#417B95" },
    { extension: 'php',  name: 'PHP', color: "#805D9D" },
    { extension: 'py',   name: 'Python', color: "#417B95" }, 
    { extension: 'java', name: 'Java', color: "#A33236" },
    { extension: 'kt',   name: 'Kotlin', color: "#B66129" },
    { extension: 'go',   name: 'Go', color: "#417B95" },
    { extension: 'rs',   name: 'Rust', color: "#57666B" },
    { extension: 'c',   name: 'C', color: "#417B95" },
    { extension: 'cpp',   name: 'C++', color: "#417B95" },
    { extension: 'cc',   name: 'C++', color: "#417B95" },
    { extension: 'cxx',   name: 'C++', color: "#417B95" },
    { extension: 'cs',   name: 'C#', color: "#417B95" },
    { extension: 'swift',   name: 'Swift', color: "#B66129" },
    
    # データ形式
    { extension: 'json', name: 'JSON', color: "#A2A234" },
    { extension: 'yaml', name: 'YAML', color: "#805D9D" },
    { extension: 'yml',  name: 'YAML', color: "#805D9D" },
    { extension: 'csv',  name: 'CSV', color: "#719A3A" },
    
    # テキスト/その他
    { extension: 'txt',  name: 'Plain Text', color: "#A6A9A8" },
    { extension: 'md',   name: 'Markdown', color: "#417B95" },
    { extension: 'sh',   name: 'Shell Script', color: "#719A3A" },
    { extension: 'sql',  name: 'SQL', color: "#C4426A" }
  ]

  language_data.each do |data|
    Language.find_or_create_by!(extension: data[:extension]) do |lang|
      lang.name = data[:name]
      lang.color = data[:color]
    end
  end

  # テストデータ: ユーザー
  user1 = User.find_or_create_by!(email: "john@example.com") do |user|
    user.name = "John"
    user.password = "test00"
    user.password_confirmation = "test00"
    user.introduction = "#{user.name}です、よろしく。"
    user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user1.jpg"), filename:"sample-user1.jpg")
  end
  user2 = User.find_or_create_by!(email: "jane@example.com") do |user|
    user.name = "Jane"
    user.password = "test00"
    user.password_confirmation = "test00"
    user.introduction = "#{user.name}です、よろしく。"
    user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user2.jpg"), filename:"sample-user2.jpg")
  end
  user3 = User.find_or_create_by!(email: "doe@example.com") do |user|
    user.name = "Doe"
    user.password = "test00"
    user.password_confirmation = "test00"
    user.introduction = "#{user.name}です、よろしく。"
    user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user3.jpg"), filename:"sample-user3.jpg")
  end

  # テストデータ: 投稿
  post1 = Post.find_or_create_by!(title: "自作ポップアップ", user: user1) do |post|
    # ヒアドキュメント
    post.description = <<~MD
# プラグインなしのポップアップ作成方法
## HTML
HTMLの説明...
## JS
JSの説明...
## CSS 
CSSの説明...
    MD
  end

  erb = Language.find_by!(extension: "erb")
  js = Language.find_by!(extension: "js")
  scss = Language.find_by!(extension: "scss")

  # テストデータ:コード
  Code.find_or_create_by!(post: post1, language: erb, name: "app") do |code|
    code.content = <<~ERB
<div class="js-popup-root" id="js-popup-checkboxs">
  <button type="button" class="js-popup-close-bg"></button>
  <div class="js-popup">
    <button type="button" class="js-popup-close-btn u-btn-1 opt-size-s"><i class="fa-solid fa-xmark"></i></button>
    ここに内容
  </div>
</div>
<button type="button" class="js-popup-trigger u-btn opt-size-s" data-target="js-popup-checkboxs">ジャンル</button>
    ERB
  end
  Code.find_or_create_by!(post: post1, language: js, name: "app") do |code|
    code.content = <<~JS
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
    JS
  end
  Code.find_or_create_by!(post: post1, language: scss, name: "app") do |code|
    code.content = <<~SCSS
.js-popup {
  max-width: 100rem;
  max-height: calc(100% - 20rem);
  background-color: $d-color-bg-active;
  border: 1px solid $d-color-border-active;
  border-radius: $radius;
  overflow: auto;
  position: absolute;
  top: 50%;
  left: 50%;
  translate: -50% -50%;
  padding: 3rem;
  &-root {
    position: fixed;
    top: 0;
    left: 0;
    z-index: 1000;
    width: 100%;
    height: 100%;
    display: none;
    &.is-active {
      display: block;
    }
  }
  &-close-bg {
    position: absolute;
    top: 0;
    left: 0;
    z-index: -1;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, .75);
  }
  &-close-btn {
    position: absolute;
    top: 0;
    right: 0;
    border-top-right-radius: 0;
    border-top-left-radius: 0;
    border-bottom-right-radius: 0;
    border: 0;
  }
}
html:has(.js-popup-root.is-active) {
  overflow: hidden;
}
    SCSS
  end

  # テストデータ: グループ
  group = Group.find_or_create_by!(name: "エンジニアチーム", owner_id: user1.id) do |g|
    g.introduction = "技術共有を目的としたグループ"
  end
  GroupMember.find_or_create_by!(user: user1, group: group)
  GroupMember.find_or_create_by!(user: user2, group: group)
  GroupMember.find_or_create_by!(user: user3, group: group)
end