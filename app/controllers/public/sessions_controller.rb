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


  # falseだった場合、退会しているのでサインアップ画面に遷移する
  
  # ログイン処理が実行される前に、在席or退会ステータス（user.isactive）を確認し、アクティブな場合はログイン処理を実行、退会していた場合はサインアップ画面に遷移する。
  def user_state
    # ログイン画面から送られたemailを確認し、Userモデルに該当するemailのアカウントが存在するか検索
    user = User.find_by(email: params[:user][:email])
    
    # アカウントが取得できなければメソッド終了
    return if user.nil?

    # アカウントのパスワードと、ログイン画面で入力されたパスワードが一致していない場合、メソッドを終了
    return unless user.valid_password?(params[:user][:password])

    # アカウントのis_activeカラムに格納されている値を確認する
    unless user.is_active?
      redirect_to new_user_registration_path, alert: "このアカウントは退会されています"
    end
  end
end
