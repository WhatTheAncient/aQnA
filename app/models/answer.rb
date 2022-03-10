class Answer < ApplicationRecord
  include Linkable
  include Fileable
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: 'user_id', inverse_of: :answers

  validates :body, presence: true

  before_destroy :clear_best_answer

  def best?
    question.best_answer_id == id
  end

  private

  def clear_best_answer
    question.update(best_answer_id: nil) if question.best_answer_id == id
  end
end
