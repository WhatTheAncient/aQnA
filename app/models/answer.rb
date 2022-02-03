class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: 'user_id', inverse_of: :created_answers

  def set_author(user)
    self.author = user
  end

  validates :body, presence: true
end
