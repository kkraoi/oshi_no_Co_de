class Group < ApplicationRecord
  has_many :group_members, dependent: :destroy
  # ↓ group.owner.name などでユーザの情報を取り出すために記述
  belongs_to :owner, class_name: "User"
  # ↓ through: 中間テーブルを通した関係の時の表現
  has_many :users, through: :group_members

  has_many :comments, as: :commentable, dependent: :destroy

  validates :name, presence: true

  # 指定したユーザーがこのグループのオーナーかどうかを判定する
  #
  # @param user [User] 判定対象のユーザーオブジェクト
  # @return [Boolean]
  #   - true: ユーザーがオーナーである場合
  #   - false: ユーザーがオーナーでない場合
  def is_owned_by?(user)
    owner.id == user.id
  end

  # 指定したユーザーがこのグループのメンバーかどうか判定する
  #
  # @param user [User] 判定対象のユーザーオブジェクト
  # @return [Boolean]
  #   - true: ユーザーがメンバーである場合
  #   - false: ユーザーがメンバーでない場合
  def member?(user)
    group_members.exists?(user_id: user.id)
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name created_at]
  end
end
