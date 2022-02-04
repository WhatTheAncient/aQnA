class Question < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'user_id', inverse_of: :questions
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
end
