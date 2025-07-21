class Public::CommentsController < Public::BaseController
  def create
    @commentable = find_commentable

    # new(comment_param) にしない => ポリモーフィック関連ではbuildが最適。
    # build() => has_many や has_one の関連先オブジェクト生成する。able_id/able_typeを自動的に補完する。
    # new() => 生どんなモデルでも汎用的に使えるが、自分で設定しないといけない
    @comment = @commentable.comments.build(comment_params)

    @comment.sentiment_score = GoogleLanguage.get_sentiment_data(comment_params[:content]);

    @comment.user = current_user

    if @comment.save
      if @commentable.is_a?(Post)
        update_recommend_score(@commentable)
      end

      respond_to do |format|
        # polymorphic_path => オブジェクトに応じたURLを自動生成する。
        format.html { redirect_to polymorphic_path(@commentable), notice: 'コメントを投稿しました' }
        format.js
      end
    else
      redirect_to polymorphic_path(@commentable, anchor: "chat"), alert: "コメントの投稿に失敗しました。また、空の投稿はできません。"
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])

    # 自分のコメントかチェック
    if @comment.user == current_user
      commentable = @comment.commentable
      @comment.destroy

      if commentable.is_a?(Post)
        update_recommend_score(commentable)
      end

      redirect_to polymorphic_path(commentable, anchor: 'chat'), notice: 'コメントを削除しました'
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

  # 投稿に紐づく有効なコメントの感情スコア平均を計算し、Postのrecommend_scoreに保存する
  #
  # 無効（is_active: false）やスコアが存在しないコメントは除外される。
  #
  # @param post [Post] 対象の投稿
  # @return [void]
  def update_recommend_score(post)
    scores = post.comments
      .where.not(sentiment_score: nil)
      .where(is_active: true)
      .pluck(:sentiment_score)

    if scores.any?
      average = scores.sum / scores.size
      post.update(recommend_score: average)
    end
  end
end
