class ApplicationController < ActionController::Base
  before_action :gon_user, unless: :devise_controller?

  check_authorization

  rescue_from CanCan::AccessDenied do |e|
    redirect_to root_url, alert: e.message
  end

  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
