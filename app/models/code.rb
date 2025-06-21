class Code < ApplicationRecord
  belongs_to :post
  belongs_to :language

  validates :name, presence: true
  validates :content, presence: true
  validates :language_id, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[language_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %W[language]
  end
end
