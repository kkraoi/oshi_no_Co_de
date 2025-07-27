class Public::InterviewsController < Public::BaseController  
  # ゲストユーザー制限
  include GuestUserRestriction

  # 他人のアクセス防止
  before_action :ensure_correct_user, only: [:new, :update, :edit, :destroy, :gacha]

  def new
    @interview_list = Interview.where(user: [nil, current_user]);
    @interview = @user.interviews.new
  end
  
  def create
    @user = User.find(params[:user_id])
    @interview = @user.interviews.new(interview_params)

    if @interview.save
      respond_to do |format|
        format.html { redirect_to new_user_interview(@user), notice: "面接質問を作成しました" }
        format.js
      end
    else
      render :new, status: :unprocessable_entity
    end
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

  def interview_params
    params.require(:interview).permit(
      :content,
    )
  end
end
