class Admin::ReportsController < Admin::BaseController
  def index
    base = Report.includes(:comment, :user).order(created_at: :desc)
    
    if params[:resolved] == "true"
      @reports = base.where(resolved: true)
    elsif params[:resolved] == "false"
      @reports = base.where(resolved: false)
    else
      @reports = base
    end
  end
  
  def update
    @report = Report.find(params[:id])
    comment = @report.comment

    hide = params[:hide_comment] == "true"

    if hide
      comment.update(is_active: false)
    else
      comment.update(is_active: true)
    end

    # report_params.merge(resolved: true) => resolvedの変更はフォームにはないため、ストパラ「report_params」だけでは変更されない。merge(resolved: true)によって、ハッシュをストパラと合成させる。
    if @report.update(report_params.merge(resolved: true))
      redirect_to admin_reports_path, notice: '通報への対応が完了しました'
    else
      render "feedback", alert: "通報処理に失敗しました"
    end
  end
  
  def feedback
    @report = Report.find(params[:id])
  end
  
  private

  def report_params
    params.require(:report).permit(:admin_feedback)
  end
end
