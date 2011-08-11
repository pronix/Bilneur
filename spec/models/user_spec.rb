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
    it "should be verify if seller payment method verified" do
      user = Factory.create(:user, :registration_as_seller => 1)
      method = Factory(:seller_payment_method, :user => user)
      method.to_verify
      method.verify
      user.verified.should be_true
    end

    it "should not be verify if payment method not verified" do
      user = Factory.create(:user, :registration_as_seller => 1)
      method = Factory(:seller_payment_method, :user => user)
      method.to_verify
      method.reject
      user.verified.should be_false
    end

  end

end
