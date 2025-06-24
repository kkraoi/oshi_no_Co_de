class Public::GroupsController < Public::BaseController
  # ゲストユーザー制限
  include GuestUserRestriction
  
  # 他人のアクセス防止
  before_action :ensure_correct_user, only: [:update, :edit, :destroy]

  def index
    @q = Group.ransack(params[:q])
    @groups = @q.result(distinct: true)
  end
  
  def show
    @group = Group.find(params[:id])
    @members = @group.group_members
    @comments = @group.comments.includes(:user, :reports)
  end
  
  def new
    @group = Group.new
  end
  
  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      # ↓ メンバーにオーナーを加える
      @group.group_members.create(user_id: @group.owner_id)
      redirect_to group_path(@group), notice: "グループの作成に成功しました"
    else
      flash.now[:alert] = "グループの作成に失敗しました"
      render "new", status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    if @group.update(group_params)
      redirect_to group_path(@group.id), notice: "編集に成功しました"
    else
      flash.now[:alert] = "編集に失敗しました"
      render "edit", status: :unprocessable_entity
    end
  end
  
  def destroy
    @group.destroy
    redirect_to groups_path, notice: '投稿を削除しました'
  end
  
  private

  def group_params
    params.require(:group).permit(
      :name,
      :introduction
    )
  end

  # ユーザをチェック
  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path, alert: "アクセスを禁止しています"
    end
  end
end
