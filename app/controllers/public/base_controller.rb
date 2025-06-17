class Public::BaseController < ApplicationController
  before_action :authenticate_any_user!
  
  private
  
  # ログインしていない場合はアクセス禁止
  # adminユーザーはアクセス制限を通る
  def authenticate_any_user!
    unless user_signed_in? || admin_signed_in?
      redirect_to new_user_session_path, alert: "ログインしてください"
    end
  end

  # 指定されたユーザーが現在のログインユーザーでない場合、アクセスを拒否してリダイレクトします。
  #
  # @param user [User] チェック対象のユーザー
  # @return [void]
  def redirect_unless_current_user(user)
    unless user == current_user
      redirect_to user_path(current_user), alert: "アクセスを禁止しています"
    end
  end
end
