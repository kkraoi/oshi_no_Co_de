Rails.application.routes.draw do
  # ユーザー用: URL /users/sign_in ...
  # devise_for :users => ユーザーの ログイン、ログアウト、新規登録、パスワード変更など のルーティングやコントローラを自動的に用意する。
  # skip:オプション => 不要なルーティングを削除
  # controllers:オプション => 自分で用意したコントローラに差し替える。
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations", # サインアップやアカウント編集系
    sessions: 'public/sessions' # ログイン・ログアウト系
  }

  # 管理者用 URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }
end
