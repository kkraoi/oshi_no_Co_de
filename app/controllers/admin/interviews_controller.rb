class Admin::InterviewsController < Admin::BaseController

  def new
    @interview_list = Interview.where(user_id: nil);
    @interview = Interview.new
  end

  def create
    @interview = Interview.new(interview_params)
    @interview.user_id = nil # nilだと管理者が作成したことになる

    if @interview.save
      respond_to do |format|
        # ↓ JSが無効の環境の場合はhtml
        format.html {
          redirect_to new_admin_interview_path,
          notice: "面接質問を作成しました"
        }
        format.js { render "shared/interview_create" }
      end
    else
      redirect_to new_admin_interview_path, alert: '面接質問の作成に失敗しました。また、空の投稿はできません。'
    end
  end

  def edit_all
    @interviews = Interview.where(user_id: nil)
  end

  def update_all
    success = true

    params[:interviews].each do |id, attrs|
      interview = Interview.find_by(id: id, user_id: nil)

      if attrs[:_destroy] == "1"
        interview.destroy
      else
        success &&= interview.update(content: attrs[:content])
      end
    end

    if success
      redirect_to new_admin_interview_path, notice: '質問の更新に成功しました。'
    else
      @interviews = Interview.where(user_id: nil)
      flash.now[:alert] = "一部の質問の更新に失敗しました。"
      render :edit_all, status: :unprocessable_entity
    end
  end

  private

  def interview_params
    params.require(:interview).permit(
      :content,
    )
  end
end
