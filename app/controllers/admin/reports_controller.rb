class Admin::ReportsController < Admin::BaseController
  def index
    base = Report.includes(:comment, :user).order(created_at: :desc)
    
    if params[:resolved] == "true"
      @reports = base.where(resolved: true).page(params[:page]).per(10)
    elsif params[:resolved] == "false"
      @reports = base.where(resolved: false).page(params[:page]).per(10)
    else
      @reports = base.page(params[:page]).per(10)
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
    @report.assign_attributes(report_params.merge(resolved: true))
    if @report.valid?(:admin)
      @report.save(validate: false)
      redirect_to admin_reports_path, notice: '通報への対応が完了しました'
    else
      flash.now[:alert] = '通報処理に失敗しました'
      render :feedback
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
