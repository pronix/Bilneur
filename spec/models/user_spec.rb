require 'spec_helper'

describe User do
  before(:all) { Role.create :name => "admin" }


  context "#create as seller" do
    it "should have role a 'seller'" do
      user = Factory.create(:user, :registration_as_seller => 1)
      user.has_role?("seller").should be_true
    end
  end

  context "#create without seller" do
    it "should not have role a 'seller'" do
      user = Factory.create(:user)
      user.has_role?("seller").should be_false
    end
  end
  context "#verivication seller" do
    pending ": TODO verification seller account"
  end
end
