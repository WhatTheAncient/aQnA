class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :author, class_name: 'User', foreign_key: 'user_id', inverse_of: :comments

  validates :body, presence: true
end
