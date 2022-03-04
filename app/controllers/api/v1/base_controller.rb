class Api::V1::BaseController < ApplicationController
  skip_authorization_check
  before_action :doorkeeper_authorize!

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  alias current_user current_resource_owner
end