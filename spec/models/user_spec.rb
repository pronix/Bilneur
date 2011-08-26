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

  describe "Rating. After create simple user review without user" do
    user = Factory(:user)
    Factory(:seller_review, :rating => 4)
    user.recalculate_rating
    user.avg_rating.should == 0.0
    user.reviews_count.should == 0
  end

  describe "Rating. Create rating for user with reculculate" do
    user = Factory(:user)
    Factory(:seller_review, :rating => 4, :seller => user)
    user.recalculate_rating
    user.avg_rating.should == 4.0
    user.reviews_count.should == 1
  end

  describe "Rating. Should be avtomaticaly reculculate, when reviews created" do
    user = Factory(:user)
    for i in %w{ 3 5 3} do
      Factory(:seller_review, :rating => i.to_i, :seller => user)
    end
    user.reviews_count.should == 3
    user.avg_rating.to_f.round(1).should == 3.7
  end

  describe "Work with favorite sellers" do
    user = Factory(:user)
    seller = Factory(:user)
    user.add_seller_to_favorite(seller)
    user.favorite_sellers.count.should == 1
    user.favorite_sellers.last.should == seller
    user.seller_favorite?(seller).should == true
    user.remove_seller_from_favorite(seller)
    user.favorite_sellers.count.should == 0
  end

end
