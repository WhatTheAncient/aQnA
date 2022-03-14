class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    authorize! :create, Subscription
    @subscription = current_user.subscriptions.new(subscription_params)
    flash.now[:notice] = 'You successfully subscribed on question.' if @subscription.save
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    authorize! :destroy, @subscription
    flash.now[:notice] = 'You successfully unsubscribed from question' if @subscription.destroy
  end

  private

  def subscription_params
    params.permit(:id, :question_id)
  end
end
