class RelationshipsController < Public::BaseController
  # ゲストユーザー制限
  include GuestUserRestriction

  # 他人のアクセス防止
  before_action :ensure_correct_user, only: [:create, :destroy]

  def create
    current_user.follow(@user)
    redirect_to request.referer
  end
  
  def destroy
    current_user.unfollow(@user)
    redirect_to request.referer
  end

  private

  # ユーザをチェック
  def ensure_correct_user
    @user = User.find(params[:user_id])
    redirect_unless_current_user(@user)
  end
end