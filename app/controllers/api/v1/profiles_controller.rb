class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: :profile

  def me
    render json: current_user
  end

  def other
    @other_profiles = User.all.where.not(id: current_user.id)
    render json: @other_profiles
  end
end