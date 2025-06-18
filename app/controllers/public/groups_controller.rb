class Public::GroupsController < Public::BaseController
  # 他人のアクセス防止
  before_action :ensure_correct_user, only: [:update, :edit, :destroy]

  def index
    @group = Group.all
  end
  
  def show
    
  end
  
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
