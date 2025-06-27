# メモ書き

## HTTPSの設定中断(6/22)
HTTPSを学ぼう > Certbotを実装する で中断。
ドメインを取得していないため。
最終デプロイが完了したら行う。
```
  323  sudo wget -r --no-parent -A 'epel-release-*.rpm' https://archives.fedoraproject.org/pub/archive/epel/7/x86_64/Packages/e/
  324  sudo rpm -Uvh archives.fedoraproject.org/pub/archive/epel/7/x86_64/Packages/e/epel-release-*.rpm
  325  sudo yum-config-manager --enable epel*
  326  sudo yum install -y certbot python2-certbot-nginx
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
      <div class="u-scroll-target js-menu-sec" id="<%= @sections[0][:id] %>">
        <section class="u-sec">
          <div class="u-inner-4 u-vert-30">
            <h2 class="u-title-1 js-menu-sec_title"><%= @sections[0][:title] %></h2>

            <!-- コンテント -->
            <div class="p-content u-vert-10"></div>
            <!-- end コンテント -->

            <!-- コード -->
            <figure class="js-code u-code">
              <pre class="prettyprint js-code-pre"></pre>
              <button class="js-code-copy_btn u-code-copy_btn u-btn-1 type-1" aria-label="コードをコピーする">
                <i class="fa-solid fa-copy"></i>
              </button>
            </figure>
            <!-- end コード -->

            <!-- その他 -->
            <div class="p-other"></div>
            <!-- end その他 -->
          </div>
        </section>
      </div>
      <!-- end テンプレ -->
```