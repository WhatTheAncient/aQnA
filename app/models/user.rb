class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, inverse_of: :author, class_name: 'Question',
                               foreign_key: 'user_id', dependent: :destroy
  has_many :answers, inverse_of: :author, class_name: 'Answer',
                             foreign_key: 'user_id', dependent: :destroy

  def author_of?(resource)
    resource.user_id == id
  end
end
