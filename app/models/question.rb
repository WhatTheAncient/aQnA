class Question < ApplicationRecord
  include Linkable
  include Fileable
  include Votable
  include Commentable

  belongs_to :author, class_name: 'User', foreign_key: 'user_id', inverse_of: :questions
  belongs_to :best_answer, class_name: 'Answer', foreign_key: 'best_answer_id', optional: true
  has_many :answers, dependent: :destroy
  has_one :reward, dependent: :destroy

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  def set_best_answer(answer)
    if answer_ids.include?(answer.id.to_i)
      update!(best_answer_id: answer.id)
      reward.update!(user: answer.author) if reward
    end
  end

  after_create :calculate_reputation

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
