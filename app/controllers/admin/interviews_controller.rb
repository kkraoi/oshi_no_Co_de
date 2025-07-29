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

  private

  def interview_params
    params.require(:interview).permit(
      :content,
    )
  end
end
