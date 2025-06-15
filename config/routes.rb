Rails.application.routes.draw do
  # ユーザー用認証系: URL /users/sign_in ...
  # devise_for :users => ユーザーの ログイン、ログアウト、新規登録、パスワード変更など のルーティングやコントローラを自動的に用意する。
  # skip:オプション => 不要なルーティングを削除
  # controllers:オプション => 自分で用意したコントローラに差し替える。
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations", # サインアップやアカウント編集系
    sessions: 'public/sessions' # ログイン・ログアウト系
  }

  # ユーザー側
  # scopeメソッド: ブロック内に書かれたルーティングはpathやprefixが変更することなく、module:オプションに与えられたモジュールをコントローラの中から探し出して、ルーティングするようになる。
  scope module: :public do
    root to: "homes#top"
    get "/about", to: "homes#about"

    # as:によってprefixができる
    get "/users/:id/posts", to: "users#posts", as: "user_posts"
    resources :users, only: [:index, :show, :edit, :update, :destroy]

    resources :posts
  end

  # 管理者用認証系 URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  # 管理者側
  # namespaceメソッド: ブロック内に書かれたルーティングはすべて `/admin/〜` というパスになり、引数のモジュール（シンボル）をコントローラの中から探し出して、ルーティングするようになる。「scope module: シンボル」と比べるとpathやprefixが変更される。
  namespace :admin do
    root to: "homes#top"
    delete "user/:id", to: "homes#destroy_user", as: "destroy_user"
    get "/style_cheatsheet", to: "homes#style_cheatsheet"

    resources :post_options, only: [:index]
  end
end
