class Public::UsersController < Public::BaseController
  # 他人のアクセス防止
  before_action :ensure_correct_user, only: [:update, :edit, :destroy]

  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id]);
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "編集に成功しました"
    else
      render "edit"
    end
  end
  
  def destroy
    
  end
  
  def posts
    
  end
  
  private

  def user_params
    params.require(:user).permit(
      :name,
      :introduction,
      :profile_image,
      :github
    )
  end

  # ユーザをチェック
  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user), alert: "アクセスを禁止しています"
    end
  end
end
