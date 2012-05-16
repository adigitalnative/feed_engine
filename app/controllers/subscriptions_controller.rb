class SubscriptionsController < ApplicationController
  def create
    subscription = current_user.inverse_subscriptions.build(user_id: params["user_id"])
    if subscription.save
      render :json => true
    else
      render :json => false
    end
  end

  def destroy
    subscription = current_user.inverse_subscriptions.where(user_id: params["user_id"]).first
    if subscription.destroy
      render :json => true
    else
      render :json => false
    end
  end
end
