class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "comments"
  end
end
