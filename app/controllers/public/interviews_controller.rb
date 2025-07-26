class Public::InterviewsController < Public::BaseController  
  # ゲストユーザー制限
  include GuestUserRestriction

    # 他人のアクセス防止
    before_action :ensure_correct_user, only: [:new, :update, :edit, :destroy, :gacha]

  def new
    
  end
  
  def create
    
  end
  
  def edit
    
  end
  
  def update
    
  end
  
  def destroy
    
  end

  def gacha
    
  end
  
private

  # ユーザをチェック
  def ensure_correct_user
    @user = User.find(params[:user_id])
    unless @user == current_user
      redirect_to user_path(current_user), alert: "アクセスを禁止しています"
    end
  end
end
