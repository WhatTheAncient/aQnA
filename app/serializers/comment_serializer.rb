class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_id, :created_at, :updated_at

  belongs_to :author, class_name: 'User'
end