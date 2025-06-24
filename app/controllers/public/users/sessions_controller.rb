class Public::Users::SessionsController < Devise::SessionsController
  def guest_sign_in
    user = User.guest
    sign_in user # ゲストユーザーをログイン状態にする
    redirect_to posts_path, notice: 'guestuserでログインしました'
  end
end