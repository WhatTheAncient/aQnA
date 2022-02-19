module VotedHelper

  def vote_path(votable, *params)
    path = "/#{votable_resource(votable)}/#{votable.id}/vote"
    if params
      path += '?'
      params[0].each_pair do |key, value|
        path += "#{key}=#{value}&"
      end
    end

    path
  end

  def unvote_path(votable, *params)
    path = "/#{votable_resource(votable)}/#{votable.id}/unvote"
    if params
      path += '?'
      params[0].each_pair do |key, value|
        path += "#{key}=#{value}&"
      end
    end

    path
  end

  private

  def votable_resource(votable)
    votable.class.model_name.route_key
  end
end
