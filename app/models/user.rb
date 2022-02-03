class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :created_questions, inverse_of: :author, class_name: 'Question',
                               foreign_key: 'user_id', dependent: :destroy

  def author_of?(resource)
    created_questions.include? resource
  end
end
