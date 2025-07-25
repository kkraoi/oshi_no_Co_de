# ログイン機能を管理する

# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  # 

  # ログイン後の遷移先を返す
  #
  # @param resource [User] ログインしたユーザーのインスタンス
  # @return [String] リダイレクト先のパス（URLまたはパスヘルパー）
  def after_sign_in_path_for(resource)
    # TODO: 遷移先のパス = 投稿一覧ページ
  end

  # ログアウト後の遷移先を返す
  #
  # @param resource_or_scope [Symbol, Class] ログアウト対象のスコープ（例: :user, :admin）
  # @return [String] リダイレクト先のパス（URLまたはパスヘルパー）
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
