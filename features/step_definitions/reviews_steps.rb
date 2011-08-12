Then /^sleep "(\d+)"$/ do |time|
  sleep time.to_i
end

Given /^the following products was created by  "(.+)" user:$/ do |user_email, table|
  user = User.find_by_email(user_email)
  table.hashes.each do |product|
    new_product = Factory(:product, product.merge({ :owner => user }))
    # user.products.create(product)
    # new_product.variants.create(:sku => "sku_#{rand(100000)}",
    #                             :price => 1,
    #                             :cost_price => 1,
    #                             :count_on_hand => 10,
    #                             :is_master => true)
    new_product.variants.create(:condition => "used", :price => 122, :seller => user, :count_on_hand => 10 )
  end
end

Given /^the following reviews with rating "(\d+)" and product "(.+)"$/ do |rating, product_name, table|
  product = Product.find_by_name(product_name)
  table.hashes.each do |review|
    new_review = product.reviews.build(review)
    new_review.rating = rating
    new_review.save
  end
  # Recalculate rating for this product
  product.recalculate_rating
end

Then /^I should see overall rating with "(\d+)" stars$/ do |rating|
  within('.top') do
    page.should have_xpath("//img[contains(@src, \"yel_str.png\")]", :count => rating.to_i)
  end
end

Then /^I should see all approved reviews for "(.+)" product$/ do |product_name|
  Product.find_by_name(product_name).reviews.each do |review|
    find_by_id("review_id_#{review.id}").should have_content(review.review)
    find_by_id("review_id_#{review.id}").find(:xpath, "//img[contains(@src, \"yel_str_sml.png\")]", :count => review.rating)
    find_by_id("review_id_#{review.id}").should have_content(review.simple_username)
  end
end

Then /^I fill the form new_review with given value$/ do |table|
  table.hashes.each do |hash|
    find(:xpath, "//input[@type='radio' and @name='review[rating]' and @value=\"#{hash['Rating']} stars\"]").set(true)
    And %{I fill in "review_name" with "#{hash['Name']}"}
    And %{I fill in "review_review" with "#{hash['Review']}"}
  end
end

Then /^I rate this by "(\d+)"$/ do |rating|
  find(:xpath, "//input[@type='radio' and @name='review[rating]' and @value=\"#{rating} stars\"]").set(true)
end

Then /^please define last Review by review "(.+)" as @review$/ do |review|
  @review = Review.find_by_review(review)
end


Then /^I should see that this review add and has status not approved$/ do
  @review.approved.should_not be_true
end

Then /^I change status for this review by approved$/ do
  @review.update_attributes(:approved => true)
end

Then /^I should not see my review on the page$/ do
  page.should_not have_content(@review.review)
end

Then /^I should see my review on the page$/ do
  find_by_id("review_id_#{@review.id}").should have_content(@review.review)
end

Then /^I approved my review$/ do
  @review.update_attributes(:approved => true)
end

Then /^I should see my review$/ do
  find_by_id("review_id_#{@review.id}").should have_content(@review.review)
end

Then /^I should see my name "(.+)" with my review$/ do |user_name|
  find_by_id("review_id_#{@review.id}").should have_content(user_name)
end


Then /^I should see my photo as "(.+)"$/ do |email|
  user = User.find_by_email(email)
  page.should have_xpath("//img[contains(@src, \"#{user.photo.url(:for_review)}\")]")
end

Then /^I should see lates review on last review block$/ do
  Review.last_reviews(3).each do |review|
    find('.vwer').should have_content(review.review)
    find('.vwer').should have_xpath("//img[contains(@src, \"missing_medium_for_review.png\")]")
  end
end

Then /^I should see all review setting options$/ do
  ['Include Unapproved', 'Preview Size', 'Show Email', 'Require Login'].each do |setting|
    find('#content').should have_content(setting)
  end
end

Then /^test$/ do
  puts Spree::Reviews::Config[:require_login]
end

Given /^the guest can not create a review$/ do
  Spree::Reviews::Config.set(:require_login => true)
end
