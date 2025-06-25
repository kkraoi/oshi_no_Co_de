class Public::PostsController < Public::BaseController
  # ゲストユーザー制限
  include GuestUserRestriction

  # 他人のアクセス防止
  before_action :ensure_correct_user, only: [:update, :edit, :destroy]

  def index
    liked_post_ids = current_user.likes.pluck(:post_id) if params.dig(:q, :liked_by_me) == "1"
    puts "🦐 #{liked_post_ids}"

    q_params = params[:q]&.dup || {}
    puts "🐶 #{q_params}"
    q_params[:id_in] = liked_post_ids if liked_post_ids.present?
    puts "🐱 #{q_params}"

    @q = Post.ransack(q_params)
    puts "🐭 #{q_params}"
    @posts = @q.result(distinct: true)
    puts "🦞 #{@posts[0]}, #{@posts[1]}, #{@posts[2]}."

    @languages = Language
    .select("MIN(id) as id, name, MIN(color) as color")
    .group(:name)
    .order(:name)
    # 次のようなSQLに変換される => 
    # SELECT MIN(id) as id, name, MIN(color) as color
    # FROM languages
    # GROUP BY name
    # ORDER BY name ASC
    # 
    # MIN(id) as id, => 一意にするために、最も小さいidを代表として使う
    # name, => group句で使うキー
    # MIN(color) as color => 同じnameに対応するcolorを選ぶ
    # GROUP BY name => nameが同じ言語ごとにグループにまとめて、それぞれ1件だけ代表で取り出す
    # ORDER BY name ASC => name の昇順（A→Z）で並べる
  end
  
  def show
    @post = Post.find(params[:id])
    # .includes(:user) => N+1問題の対処、コメントと一緒に投稿者情報も取得
    @comments = @post.comments.includes(:user, :reports)
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
