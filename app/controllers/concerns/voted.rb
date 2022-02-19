module Voted
  extend ActiveSupport::Concern

  def vote
    @votable = params[:votable].constantize.find(params[:id])
    @vote = @votable.votes.new(user: current_user, state: params[:vote_state])
    if (current_user.author_of?(@vote.votable) || current_user.voted_for?(@vote.votable))
      render json: { errors: @vote.errors.full_messages }, status: :unprocessable_entity
    else
      render json: { vote: @vote, rating: @votable.rating }, status: :created if @vote.save
    end
  end

  def unvote
    @vote = Vote.find(params[:vote_id])
    if current_user.author_of?(@vote)
      @vote.destroy
      render json: { rating: @vote.votable.rating, votable_id: @vote.votable.id }
    else
      head :forbidden
    end
  end
end
