class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, inverse_of: :author, class_name: 'Question',
           foreign_key: 'user_id', dependent: :destroy
  has_many :answers, inverse_of: :author, class_name: 'Answer',
           foreign_key: 'user_id', dependent: :destroy
  has_many :comments, inverse_of: :author, class_name: 'Comment',
           foreign_key: 'user_id', dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :votes, dependent: :destroy

  def author_of?(resource)
    resource.user_id == id
  end

  def voted_for?(votable)
    !!vote_for(votable)
  end

  def vote_for(votable)
    votes.find_by(votable: votable)
  end
end