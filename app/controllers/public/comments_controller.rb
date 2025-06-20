class Public::CommentsController < Public::BaseController
  def create
    @commentable = find_commentable

    # new(comment_param) にしない => ポリモーフィック関連ではbuildが最適。
    # build() => has_many や has_one の関連先オブジェクト生成する。able_id/able_typeを自動的に補完する。
    # new() => 生どんなモデルでも汎用的に使えるが、自分で設定しないといけない
    @comment = @commentable.comments.build(comment_params)

    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        # polymorphic_path => オブジェクトに応じたURLを自動生成する。
        format.html { redirect_to polymorphic_path(@commentable), notice: 'コメントを投稿しました' }
        format.js
      end
    else
      respond_to do |format|
        format.html {
          flash[:alert] = "コメントの投稿に失敗しました"
          # redirect_back => 「直前のページ（リファラー）」にリダイレクトするためのRailsのメソッド。
          # fallback_location => リファラー（元のページ）が見つからなかったときの代わりの行き先。
          # redirect_to request.refererとの違い => request.refererは HTTPリクエストヘッダー Referer をそのまま使うが、それがない場合エラーになる。redirect_backはReferer がなければ fallback_location: に戻る。
          redirect_back fallback_location: root_path
        }
        format.js
      end
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])

    # 自分のコメントかチェック
    if @comment.user == current_user
      @comment.destroy
      redirect_back fallback_location: root_path, notice: "コメントを削除しました"
    else
      redirect_back fallback_location: root_path, alert: "権限がありません"
    end
  end
  
  private

  # PostかGroupを検索して返す
  #
  # @return [Post, Group] 検索されたコメント可能なリソース
  # @raise [ActiveRecord::RecordNotFound] 以下の場合に発生:
  #   - パラメーターが空の場合
  #   - 指定されたリソースが存在しない場合
  #   - :post_idと:group_idが両方指定された場合
  def find_commentable
    if params[:post_id]
      Post.find(params[:post_id])
    elsif params[:group_id]
      Group.find(params[:group_id])
    else
      # 「レコードが見つからない」例外処理を発生させ、404ステータスを返す
      raise ActiveRecord::RecordNotFound
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
