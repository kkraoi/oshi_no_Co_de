class Public::PostsController < Public::BaseController
  # ゲストユーザー制限
  include GuestUserRestriction

  # テキストをマークダウンHTML化する
  include MarkdownHelper

  # 他人のアクセス防止
  before_action :ensure_correct_user, only: [:update, :edit, :destroy]

  def index
    liked_post_ids = current_user.likes.pluck(:post_id) if params.dig(:q, :liked_by_me) == "1"

    q_params = params[:q]&.dup || {}
    q_params[:id_in] = liked_post_ids if liked_post_ids.present?

    @q = Post.ransack(q_params)
    @posts = @q.result.page(params[:page]).per(9)

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

    description_text = post_params[:description]
    top_entities = extract_top_entities(description_text)

    if @post.save
      build_keywords(@post_id, top_entities)
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
    description_text = post_params[:description]
    top_entities = extract_top_entities(description_text)

    if @post.update(post_params)
      # 古いエンティティを削除
      @post.post_keywords.delete_all

      # 新エンティティを作成
      build_keywords(@post.id, top_entities)

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

  # GoogleNaturalLangugageAPIからのエンティティを抽出する
  def extract_top_entities(description_text)
    html = markdown_to_html(description_text)
    entity_data = GoogleLanguage.get_entity_data(html)
    entity_data["entities"]
      .sort_by { |e| -e["salience"].to_f }
      .first(5)
    # [↑ 一連の解説]
    # array.sort_by { |element| 条件 } => ブロックの戻り値を基準にソート
    # 「-」をつけることで降順にする。
    # .to_f => 浮動小数点数にする。
  end

  # post_keywordsテーブルを作成する
  def build_keywords(post_id, top_entities)
    # top_entities.each do |entity|
      #   @post.post_keywords.create!(
      # ...にする方法もあるが、
      # 回すたびにDBを呼び出して、効率がよくない（N+1問題）
      # なので「バルクインサート」で実装する↓
      records = top_entities.map do |entity|
        {
          post_id: @post.id,
          name: entity["name"],
          salience: entity["salience"].to_f,
          entity_type: @post.id,
          created_at: @post.id,
          updated_at: @post.id
        }
      end
      PostKeyword.insert_all(records)
  end
end
