class Public::UsersController < Public::BaseController
  # 他人のアクセス防止
  before_action :ensure_correct_user, only: [:update, :edit, :destroy]

  def index
    @q = User.ransack(params[:q])
    # distinct: true => SQLのJOINが発生する場合、重複行を除去する
    @users = @q.result(distinct: true)
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
      flash.now[:alert] = "編集に失敗しました"
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    sign_out @user
    redirect_to root_path, notice: "アカウントを削除しました"
  end
  
  def posts
    @user = User.find(params[:id])
    @posts = @user.posts
  end
  
  def groups
    @user = User.find(params[:id])
    @q = @user.groups.ransack(params[:q])
    @groups = @q.result(distinct: true)
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
    redirect_unless_current_user(@user)
  end
end
