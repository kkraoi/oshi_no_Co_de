class Public::ReportsController < Public::BaseController
  def new
    @comment = Comment.find(params[:comment_id])
    existing_report = @comment.reports.find_by(user: current_user)
    @is_reported = existing_report.present?
    @reported_id = existing_report&.id
    @report = @comment.reports.build
  end
  
  def create
    @comment = Comment.find(params[:comment_id])
    @report = @comment.reports.build(report_params)
    @report.user = current_user
    if @report.save
      redirect_to complete_reports_path, notice: 'フォームの送信に成功しました'
    else
      flash.now[:alert] = "フォームの送信に失敗しました"
      render "new", status: :unprocessable_entity
    end
  end
  
  def destroy
    @report = Report.find(params[:id])
    @report.comment
    if @report.destroy
      redirect_to "#{request.referer}#comment-#{@report.comment.id}", notice: '通報を取り消しました'
    else
      redirect_to "#{request.referer}#comment-#{@report.comment.id}", notice: '通報を取り消しに失敗しました'
    end
  end
  
  private

  def report_params
    params.require(:report).permit(:reason)
  end
end
