class Public::PostsController < ApplicationController
  def index
    
  end
  
  def show
    @post = Post.find(params[:id])
  end
  
  def new
    @post = Post.new
  end
  
  def create
    post = Post.new(post_params)
    post.user_id = current_user.id
    if post.save
      redirect_to post_path(post), notice: "投稿に成功しました"
    else
      render "new", alert: "投稿に失敗しました"
    end
  end
  
  def edit
    
  end
  
  def update
    
  end
  
  def destroy
    
  end
  
  private

  def post_params
    params.require(:post).permit(
      :title,
      :summary,
      :description
    )
  end
end
