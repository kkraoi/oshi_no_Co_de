class Public::PostsController < Public::BaseController
  # 他人のアクセス防止
  before_action :ensure_correct_user, only: [:update, :edit, :destroy]

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true)

    @languages = Language
    .select("MIN(id) as id, name, MIN(color) as color")
    .group(:name)
    .order(:name)
  end
  
  def show
    @post = Post.find(params[:id])
    # .includes(:user) => N+1問題の対処、コメントと一緒に投稿者情報も取得
    @comments = @post.comments.includes(:user)
  end
  
  def new
    @post = Post.new

    # build => 新しい関連オブジェクトを作るメソッド。「fields_for :codes」は「@post.codes」に要素がないとフォームを用意しない。そこでbuildをすることで空のCodeをあらかじめ作る。
    @post.codes.build

    # .allではなく.order(:extension) => extensionカラムをアルファベット順に直す
    @languages = Language.order(:extension)
  end
  
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post), notice: "投稿に成功しました"
    else
      @languages = Language.order(:extension)
      flash.now[:alert] = "投稿に失敗しました"
      # status: :unprocessable_entity: バリデーションを必要とするアクションで使う
      # ↓フォームのエラーステータス（422）が返る
      render "new", status: :unprocessable_entity
    end
  end
  
  def edit
    @languages = Language.order(:extension)
  end
  
  def update
    if @post.update(post_params)
      redirect_to post_path(@post.id), notice: "編集に成功しました"
    else
      @languages = Language.order(:extension)
      flash.now[:alert] = "編集に失敗しました"
      render "edit", status: :unprocessable_entity
    end
  end
  
  def destroy
    if @post.destroy
      redirect_to posts_path, notice: '投稿を削除しました'
    else
      render "edit", alert: "投稿の削除に失敗しました"
    end
  end
  
  private

  def post_params
    params.require(:post).permit(
      :title,
      :summary,
      :description,
      # ↓子モデルを扱う。:_destroy => 「accepts_nested_attributes_for :codes, allow_destroy: true」に対応している。項目を削除するときに、railsにその意図を伝えるフラグ。値が"1"やtrueになると、保存時に＠post.codes[i]を削除する。
      codes_attributes: [:id, :name, :content, :language_id, :_destroy]
    )
  end

  # ユーザをチェック
  def ensure_correct_user
    @post = Post.find(params[:id])
    @user = User.find(@post.user.id)
    unless @user == current_user
      redirect_to user_path(current_user), alert: "アクセスを禁止しています"
    end
  end
end
