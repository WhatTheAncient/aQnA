module Voted
  extend ActiveSupport::Concern

  def vote
    @votable = params[:votable].constantize.find(params[:id])
    authorize! :vote, @votable

    @vote = @votable.votes.new(user: current_user, state: params[:vote_state])
    render json: { vote: @vote, rating: @votable.rating }, status: :created if @vote.save
  end

  def unvote
    @vote = Vote.find(params[:vote_id])
    authorize! :unvote, @vote.votable

    @vote.destroy
    render json: { votable_id: @vote.votable.id, rating: @vote.votable.rating, votable_name: @vote.votable.class.to_s }
  end
end
