class Post < ApplicationRecord
  belongs_to :user

  # inverse_of: :post => 通常、code.postを呼び出す場合、post_idをもとにDBに問い合わせるが、inverse_of: :postを設定することで、メモリ上にある@postオブジェクトを使って呼び出すようになり、再見込みをせず、無駄なSQLを発行しないようになる。
  # また、下記の「accepts_nested_attributes_for :codes」を扱う場合、codeモデルのバリデでpostにアクセスする時、postはまだ保存されていないことになり、エラーになる。これを防ぐためでもある。
  has_many :codes, inverse_of: :post, dependent: :destroy

  # 1つのフォームから関連モデル（Code）も一緒に作成・更新・削除できるようにするための設定。
  # accepts_nested_attributes_for :codes => 親モデル（Post）のフォームから、子モデル（Code）を一緒に作成・編集できるようにするメソッド。これによって「f.fields_for :codes do |code_fields|」が使えるようになる。
  # allow_destroy: true: 子モデル（Code）に対して、「削除」のチェックを付けられるようにする。「<%= code_fields.check_box :_destroy %>」で削除フラグを送れる
  accepts_nested_attributes_for :codes, allow_destroy: true

  # 指定された日時属性を日本時間で「YYYY/MM/DD」形式に整形して返す
  #
  # @param attribute [Symbol] 整形対象の日付属性。デフォルトは :updated_at
  # @return [String] フォーマット済みの日付（例: "2025/06/15"）
  def format_date(attribute = :update_at)
    self[attribute].in_time_zone("Asia/Tokyo").strftime("%Y/%m/%d")
  end
end
