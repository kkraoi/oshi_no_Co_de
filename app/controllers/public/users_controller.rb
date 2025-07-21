class Public::UsersController < Public::BaseController
  # ゲストユーザー制限
  include GuestUserRestriction
  
  # 他人のアクセス防止
  before_action :ensure_correct_user, only: [:update, :edit, :destroy]

  def index
    @q = User.where.not(email: User::GUEST_USER_EMAIL).ransack(params[:q])
    # distinct: true => SQLのJOINが発生する場合、重複行を除去する
    @users = @q.result(distinct: true).page(params[:page]).per(10)
  end
  
  def show
    @user = User.find(params[:id]);
    @achievements = @user.achievements
  end
  
  def edit
    max_fields = 3 # フィールドの上限数
    current_count = @user.achievements.size

    # フィールドを上限数の分作成する。
    (max_fields - current_count).times { @user.achievements.build }
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
    @q = @user.posts.ransack(params[:q])
    @posts = @q.result(distinct: true).order(created_at: :desc).page(params[:page]).per(9)
    @languages = Language
      .select("MIN(id) as id, name, MIN(color) as color")
      .group(:name)
      .order(:name)
  end
  
  def groups
    @user = User.find(params[:id])
    @q = @user.groups.ransack(params[:q])
    @groups = @q.result(distinct: true).order(created_at: :desc).page(params[:page]).per(10)
  end

  def relationships
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page]).per(12)
    @followers = @user.followers.page(params[:page]).per(12)
  end
  
  private

  def user_params
    params.require(:user).permit(
      :name,
      :introduction,
      :profile_image,
      :github,
      achievements_attributes: [:id, :title, :description, :link, :thumb, :_destroy]
    )
  end

  # ユーザをチェック
  def ensure_correct_user
    @user = User.find(params[:id])
    redirect_unless_current_user(@user)
  end
end
