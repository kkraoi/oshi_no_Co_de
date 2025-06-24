class Users::SessionsController < Devise::SessionsController
  def guest_sign_in
    user = User.guest
    sign_in user # ゲストユーザーをログイン状態にする
    redirect_to user_path(user), notice: 'guestuserでログインしました'
  end
end