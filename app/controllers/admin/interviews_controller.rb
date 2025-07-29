class Admin::InterviewsController < Admin::BaseController

  def new
    @interview_list = Interview.where(user: nil);
    @interview = Interview.new
  end

  def create
    @interview = Interview.new(interview_params)
    @interview.user_id = nil # nilだと管理者が作成したことになる

    if @interview.save
      
    else
    end
  end

  private

  def interview_params
    params.require(:interview).permit(
      :content
    )
  end
end
