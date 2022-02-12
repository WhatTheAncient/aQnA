class Question < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'user_id', inverse_of: :questions
  belongs_to :best_answer, class_name: 'Answer', foreign_key: 'best_answer_id', optional: true
  has_many :answers, dependent: :destroy

  has_many_attached :files

  validates :title, :body, presence: true
end
