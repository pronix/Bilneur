Then /^"(.+)" should be my favorite seller$/ do |seller_email|
  @user.seller_favorite?(User.find_by_email(seller_email)).should be_true
end

Then /^I as non register user should have "(.+)" favorite seller$/ do |seller_email|
  session[:favorite_sellers].should == User.find_by_email(seller_email).id
end

Then /^I have "(.+)" as favorite seller$/ do |seller_email|
  @user.add_seller_to_favorite(User.find_by_email(seller_email))
  @user.favorite_sellers.count.should == 1
end

Then /^I should have (\d+) favorite sellers$/ do |fav_count|
  @user.favorite_sellers.count.should == 2
end
