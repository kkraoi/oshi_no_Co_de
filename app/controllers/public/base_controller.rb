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
end
