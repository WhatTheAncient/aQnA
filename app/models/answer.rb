class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: 'user_id', inverse_of: :answers

  validates :body, presence: true
end
