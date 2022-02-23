class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: %i[create]

  def create
    @comment = current_user.comments.create(body: comment_params[:body],
                                         commentable_type: params[:commentable_type],
                                         commentable_id: params[:commentable_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    unless @comment.errors.any?
      rendered_comment = ApplicationController.render(
        partial: 'comments/comment',
        locals: { comment: @comment }
      )

      ActionCable.server
                 .broadcast('comments',
                            {
                              comment: rendered_comment,
                              commentable_type: @comment.commentable_type.underscore,
                              commentable_id: @comment.commentable_id
                            })
    end
  end
end
