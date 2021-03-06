require 'spec_helper'

describe Message do
  let(:user) { FactoryGirl.create(:user) }
  let!(:message) { Message.create(comment: "A witty joke", user: user) }

  describe "#new" do
    context "when my message is valid" do
      it "should be valid" do
        message.should be_valid
      end
    end

    context "when my message is longer than 512 characters" do
      it "should be invalid" do
        message.comment = 'a' * 513
        message.should_not be_valid
      end
    end

    context "when my message is blank" do
      it "should be invalid" do
        message.comment = ''
        message.should_not be_valid
      end
    end
  end

  describe "#parse_hashtags" do
    context "if the message has no services prefixed with hashtags" do
      it "should return an empty array" do
        message.parse_hashtags.should be_empty
      end
    end

    context "if the message has services prefixed with hashtags" do
      it "should return an array of array of services" do
        message.comment = "#facebook #TwiTTer"
        services = message.parse_hashtags
        services.should include "facebook"
        services.should include "twitter"
        services.size.should == 2
      end
    end
  end

  describe "#send_to_services" do
    context "if the message has #twitter" do
      it "sends a tweet" do
        message.should_receive(:parse_hashtags).and_return(["twitter"])
        message.should_receive(:send_twitter_update)
        message.send_to_services
      end
    end
  end

  describe "#send_twitter_update" do
    context "when message is less than or equal to 180 characters" do
      it "should send a tweet" do
        Twitter::Client.any_instance.should_receive(:update).and_return(true)
        user.stub(:twitter_client) { Twitter::Client.new }
        message.send_twitter_update
      end      
    end

    context "when message is more than 180 characters" do
      it "should not send a tweet" do
        message.comment = "a" * 181
        message.send_twitter_update
        Twitter::Client.any_instance.should_not_receive(:update)
      end
    end
  end
end
# == Schema Information
#
# Table name: growls
#
#  id                  :integer         not null, primary key
#  type                :string(255)
#  comment             :text
#  link                :text
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#  user_id             :integer
#  photo_file_name     :string(255)
#  photo_content_type  :string(255)
#  photo_file_size     :integer
#  photo_updated_at    :datetime
#  regrowled_from_id   :integer
#  original_created_at :datetime
#  event_type          :string(255)
#

