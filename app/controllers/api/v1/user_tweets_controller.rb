class Api::V1::UserTweetsController < Api::V1::BaseController
  # respond_to :json

  def create
    tweets = JSON.parse(params["tweets"])
    tweets.each do |tweet|
      Tweet.create(tweet)
    end
    render :json => true, :status => 201
  end
end
