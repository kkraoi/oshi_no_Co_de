# メモ書き

## 本番環境で.envは使えない！
AWSは.envは読み込まれない。メンターに確認。

### 方法1: ECSのタスク定義
タスク定義内に次のように書く。
```
"environment": [
  {
    "name": "ADMIN_EMAIL",
    "value": "ほげほげ@example.com"
  },
  {
    "name": "ADMIN_PASSWORD",
    "value": "ほげほげパスワード"
  }
]
```
### 方法2: EC2で手動で設定
~/.bash_profile などに追記
```
export ADMIN_EMAIL=ほげほげ@example.com
export ADMIN_PASSWORD=ほげほげパスワード
```
そして起動前に読み込む
```
source ~/.bash_profile
```

## 特定のページのヘッドだけタグを追加
特定のページ.html.erbにて
```
<% content_for :head do %>
  <link rel="stylesheet" href="https://example.com/当該ページ専用.css">
<% end %>
```

## 早見表テンプレート
```
      <!-- テンプレ -->
      <div class="u-scroll-target js-menu-sec" id="<%= sections[0][:id] %>">
        <section class="u-sec">
          <div class="u-inner-4">
            <h2 class="u-title-1 js-menu-sec_title"><%= sections[0][:title] %></h2>

            <!-- コンテント -->
            <div class="p-content u-vert-10"></div>
            <!-- end コンテント -->

            <!-- コード -->
            <figure class="p-code">
              <pre class="prettyprint"></pre>
            </figure>
            <!-- end コード -->

            <!-- その他 -->
            <div class="p-other">
              <p></p>
            </div>
            <!-- end その他 -->
          </div>
        </section>
      </div>
      <!-- end テンプレ -->

```