class Public::GroupMembersController < Public::BaseController
  def create
    group_member = current_user.group_members.new(group_id: params[:group_id])
    if group_member.save
      redirect_to request.referer, notice: 'グループの参加に成功しました'
    else
      redirect_to request.referer, alert: 'グループの参加に失敗しました'
    end
  end
  
  def destroy
    group_member = current_user.group_members.find_by(group_id: params[:group_id])
    if group_member.destroy
      redirect_to request.referer, notice: 'グループから退会しました'
    else
      redirect_to request.referer, alert: '退会処理に失敗しました'
    end
  end
end
