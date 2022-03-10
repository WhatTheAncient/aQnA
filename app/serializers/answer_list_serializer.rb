class AnswerListSerializer < ActiveModel::Serializer
  attributes :id, :body, :rating, :best?, :created_at, :updated_at

  belongs_to :author

  def rating
    object.votes.sum(:state)
  end

  def best?
    object.best?
  end
end
