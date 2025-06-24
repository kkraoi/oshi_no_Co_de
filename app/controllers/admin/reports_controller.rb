class Admin::ReportsController < Admin::BaseController
  def index
    @reports = Report.includes(:comment, :user)
    .where(resolved: false)
    .order(created_at: :desc)
  end
  
  def update
    
  end
  
  def feedback
    
  end
  
  def hide_comment
    
  end
  
  private
end
