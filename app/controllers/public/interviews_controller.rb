class Public::InterviewsController < Public::BaseController  
  # ゲストユーザー制限
  include GuestUserRestriction

  # 他人のアクセス防止
  before_action :ensure_correct_user, only: [:new, :update_all, :edit_all, :destroy, :gacha]

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
        format.js { render "shared/interview_create"}
      end
    else
      @interview_list = Interview.where(user: [nil, current_user]);
      flash.now[:alert] = "面接質問の作成に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def edit_all
    @interviews = @user.interviews
  end

  def update_all
    success = true

    params[:interviews].each do |id, attrs|
      interview = @user.interviews.find_by(id: id)

      if attrs[:_destroy] == "1"
        interview.destroy
      else
        success &&= interview.update(content: attrs[:content])
      end
    end

    if success
      redirect_to new_user_interview_path(@user), notice: '質問の更新に成功しました。'
    else
      flash.now[:alert] = "一部の質問の更新に失敗しました。"
      render :edit_all, status: :unprocessable_entity
    end
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
