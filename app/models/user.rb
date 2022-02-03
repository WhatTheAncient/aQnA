class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :created_questions, inverse_of: :author, class_name: 'Question',
                               foreign_key: 'user_id', dependent: :destroy
  has_many :created_answers, inverse_of: :author, class_name: 'Answer',
                             foreign_key: 'user_id', dependent: :destroy

  def author_of?(resource)
    (created_questions.include? resource) || (created_answers.include? resource)
  end
end
