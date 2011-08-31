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

Then /^show me the cookies!$/ do
  show_me_the_cookies
end

Given /^I close my browser$/ do
  delete_cookie Rails.application.config.session_options[:key]
end

Then /^I have following sellers as favorite:$/ do |table|
  table.hashes.each { |hash| @user.favorite_sellers << User.find_by_email(hash[:email]) }
  @user.favorite_sellers.count.should == table.hashes.size
end

Then /^I should all (\d+) favorite sellers$/ do |count_seller|
  favorite_sellers = @user.favorite_sellers
  favorite_sellers.count.should == count_seller.to_i
  favorite_sellers.each { |seller| page.should have_content(seller.full_name) }
end

Then /^I should not see favorite seller "(.+)" "(.+)" on the page$/ do |user_email, field|
  page.should_not have_content(User.find_by_email(user_email).send(field))
end

Then /^I should not have "(.+)" as my favorite seller$/ do |user_email|
  @user.favorite_sellers.find_by_email(user_email).should == nil
end
