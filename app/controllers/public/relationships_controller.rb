class Public::RelationshipsController < Public::BaseController
  def create
    user = User.find(params[:user_id])

    if current_user != user
      current_user.follow(user)
    else
      flash[:alert] = "自分自身をフォローすることはできません"
    end

    redirect_to request.referer || root_path
  end
  
  def destroy
    user = User.find(params[:user_id])

    if current_user != user
      current_user.unfollow(user)
    else
      flash[:alert] = "自分自身をアンフォローすることはできません"
    end

    redirect_to request.referer || root_path
  end
end
