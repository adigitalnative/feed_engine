require 'spec_helper'

describe Subscription do
  let(:subscription) { Subscription.new }

  context "last status ID is less than the new status ID" do
    it "updates the last_status_id" do
      subscription.last_status_id = 3
      new_status_id = 9
      subscription.update_last_status_id_if_necessary(new_status_id)
      subscription.last_status_id.should == new_status_id
    end
  end
  context "last status ID is greater than the new status ID" do
    it "does not update the last_status_id" do
      last_status_id = 73
      subscription.last_status_id = last_status_id
      new_status_id = 3
      subscription.update_last_status_id_if_necessary(new_status_id)
      subscription.last_status_id.should == last_status_id
    end
  end
end
