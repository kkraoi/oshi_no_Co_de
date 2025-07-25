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
    get "/users/:id/groups", to: "users#groups", as: "user_groups"
    resources :users, only: [:index, :show, :edit, :update, :destroy] do
      resource :relationships, only: [:create, :destroy]

      # idが含まれるネストの書き方
      member do
        get :relationships
      end
    end

    resources :posts do
      resources :comments, only: [:create, :destroy]
      # ↓なぜresource？: resourceは「:id」を使わないURLを作る。いいね機能は、ユーザーは1つの投稿に対して1つしかいいねできない。このため、いいねの削除は、ユーザーIDと投稿IDのみで、どのいいねを削除するか特定できるため、:idを必要としない。それに対し、↑のcommentsはユーザーは1つの投稿に対し、複数コメントできるため、削除をするには、[:id]で特定する必要があるのでresourcesとなる。
      resource :likes, only: [:create, :destroy]
    end

    resources :groups do
      resource :group_members, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
    end

    resources :comments, only: [] do
      resources :reports, only: [:new, :create]
    end

    resources :reports, only: [:destroy] do
      # idがいらないネストの書き方
      collection do
        get :complete
      end
    end

    devise_scope :user do
      post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
    end
  end

  # 管理者用認証系 URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  # 管理者側
  # namespaceメソッド: ブロック内に書かれたルーティングはすべて `/admin/〜` というパスになり、引数のモジュール（シンボル）をコントローラの中から探し出して、ルーティングするようになる。「scope module: シンボル」と比べるとpathやprefixが変更される。
  namespace :admin do
    root to: "homes#top"
    delete "/user/:id", to: "homes#destroy_user", as: "destroy_user"
    get "/style_cheatsheet", to: "homes#style_cheatsheet"

    post "/languages", to: "post_options#create_language_option", as: "create_language_option"
    delete "/language/:id", to: "post_options#destroy_language_option", as: "destroy_language_option"
    resources :post_options, only: [:index]

    resources :users, only: [:show]

    resources :reports, only: [:index, :update] do
      member do
        get :feedback
      end
    end
  end
end
