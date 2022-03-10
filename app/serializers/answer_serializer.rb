class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :rating, :best?, :created_at, :updated_at

  belongs_to :author

  has_many :comments
  has_many :links
  has_many :files, serializer: FileSerializer

  def rating
    object.votes.sum(:state)
  end

  def best?
    object.best?
  end
end
