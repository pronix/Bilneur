Given /^I have (\d+) quoutes for product "(.+)"$/ do |quot_count, product_name|
  1.upto(quot_count.to_i) {   Factory(:variant, :seller => @user, :owner => @user, :product => Product.find_by_name(product_name)) }
end

Then /^I should see all my quotes$/ do
  @user.quotes.each do |quote|
    
  end
end
