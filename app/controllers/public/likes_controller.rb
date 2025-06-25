class Public::LikesController < Public::BaseController
  def create
    @post = Post.find(params[:post_id])
    current_user.likes.create(post: @post)
    # reload => モデルを再取得。ActiveRecordのキャッシュにより、非同期でカラムを変更しても残ったままになる問題の対処。
    @post.reload
    respond_to do |format|
      format.js
    end
  end
  
  def destroy
    @post = Post.find(params[:post_id])
    current_user.likes.find_by(post_id: @post.id)&.destroy
    @post.reload
    respond_to do |format|
      format.js
    end
  end
end
