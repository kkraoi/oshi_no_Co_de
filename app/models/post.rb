class Post < ApplicationRecord
  include FormattableDate

  belongs_to :user

  # inverse_of: :post => 通常、code.postを呼び出す場合、post_idをもとにDBに問い合わせるが、inverse_of: :postを設定することで、メモリ上にある@postオブジェクトを使って呼び出すようになり、再見込みをせず、無駄なSQLを発行しないようになる。
  # また、下記の「accepts_nested_attributes_for :codes」を扱う場合、codeモデルのバリデでpostにアクセスする時、postはまだ保存されていないことになり、エラーになる。これを防ぐためでもある。
  has_many :codes, inverse_of: :post, dependent: :destroy

  # 1つのフォームから関連モデル（Code）も一緒に作成・更新・削除できるようにするための設定。
  # accepts_nested_attributes_for :codes => 親モデル（Post）のフォームから、子モデル（Code）を一緒に作成・編集できるようにするメソッド。これによって「f.fields_for :codes do |code_fields|」が使えるようになる。
  # allow_destroy: true: 子モデル（Code）に対して、「削除」のチェックを付けられるようにする。「<%= code_fields.check_box :_destroy %>」で削除フラグを送れる
  accepts_nested_attributes_for :codes, allow_destroy: true

  has_many :comments, as: :commentable, dependent: :destroy

  validates :title, presence: true
  
 # 投稿に関連付けられたコードから、重複しない言語（Languageオブジェクト）を抽出する
  #
  # 同じ言語名（language.name）を持つ Language は1つだけ返す。
  # color や extension などの属性もそのまま使える。
  #
  # @return [Array<Language>] 言語名が重複しない Language オブジェクトの配列
  def unique_languages
    # codes.includes(:language) => N+1問題を防ぐために関連する Language をまとめて事前に読み込む。戻り値はCodeオブジェクトの配列。
    # .map(&:language) => 戻り値はLanguageオブジェクトの配列を作る。
    # ↑「&」アンパサンド記法 => .map(&:language) = map { |record| record.language }
    # .uniq {|lang| lang.name } => 配列の中から、ブロック内のプロパティを基準に重複しない配列を作る。結果、重複しないLanguageオブジェクトの配列となる。
    codes.includes(:language).map(&:language).uniq {|lang| lang.name }
  end
  
  def self.ransackable_attributes(auth_object = nil)
    %w[title created_at]
  end
end
