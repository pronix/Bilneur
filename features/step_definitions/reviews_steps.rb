Then /^sleep "(\d+)"$/ do |time|
  sleep time.to_i
end

Given /^I have product with name "(.+)" and owner "(.+)"$/ do |product_name, owner|
  user = User.find_by_email(owner)
  product = Factory(:product, :name => product_name, :owner => user)
  Factory(:variant, :product => product, :owner => user, :seller => user, :is_master => true)
  Factory(:variant, :product => product, :owner => user, :seller => user)
end

Given /^I have "(\d+)" reviews for product "(.+)" with rating "(\d+)" and approved$/ do |reviews_count, product_name, rating|
  product = Product.find_by_name(product_name)
  Factory(:review, :product => product, :rating => rating, :approved => true)
  1.upto(reviews_count.to_i) { Factory(:review, :product => product, :rating => rating, :approved => true) }
  product.recalculate_rating
end

Then /^I should see overall rating with "(\d+)" stars$/ do |rating|
  within('.top') do
    page.should have_xpath("//img[contains(@src, \"yel_str.png\")]", :count => rating.to_i)
  end
end

Then /^I should see all approved reviews for "(.+)" product$/ do |product_name|
  Product.find_by_name(product_name).reviews.approved.each do |review|
    # find_by_id("review_id_#{review.id}").should have_content(review.review)
    # find_by_id("review_id_#{review.id}").find(:xpath, "//img[contains(@src, \"yel_str_sml.png\")]", :count => review.rating)
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

Then /^I should see lates review for "(.+)" on last review block$/ do |product_name|
  Product.find_by_name(product_name).reviews.last_reviews(3).each do |review|
    find('.vwer').should have_content(review.simple_username)
  end
end

Then /^I should see all review setting options$/ do
  ['Include Unapproved', 'Preview Size', 'Show Email', 'Require Login'].each do |setting|
    find('#content').should have_content(setting)
  end
end

Then /^test$/ do
  puts Product.find_by_name("The Godfather").variants.count
end

Given /^the guest can not create a review$/ do
  Spree::Reviews::Config.set(:require_login => true)
end

Given /^I have spree preference "(.+)" with "(.+)"$/ do |option, value|
  Spree::Reviews::Config.set(option.to_sym => value)
end

Given /^I am signed and create review$/ do
  Given %{I already sing as "new_seller@person.com/password"}
  When %{I go to the "The Godfather" product page}
  Then %{I follow "Rate This Product"}
  And %{I rate this by "3"}
  And %{I fill in "review_review" with "Simple Review"}
  Then %{I press "Submit your review"}
end

Then /^I should see my fuck review$/ do
  page.should have_content("Simple Review")
end

Given /^create sample paypal paymethod$/ do
  Given %{I go to the dashboard payment_methods page}
  And %{I follow "New Payment Method"}
  And %{I select "Paypal" from "Type"}
  And %{I fill in "Name" with "My paypal"}
  And %{I press "Create"}
  When %{I fill in "Login" with "test_paypal@tpay.com"}
  And %{I fill in "Password" with "password"}
  And %{I press "Update"}
  Then %{I should see "Payment Method has been successfully updated!"}
end

Given /^I have "(\d+)" reviews for my product "(.+)"$/ do |count, product_name|
  product = Product.find_by_name(product_name)
  1.upto(count.to_i).each do ||
      Factory(:review, { :product => product, :approved => false })
  end
end

Given /^I have (\d+) unapproved and (\d+) approved reviews for product "(.+)"$/ do |unapproved, approved, product_name|
  product = Product.find_by_name(product_name)
  1.upto(unapproved.to_i) { Factory(:review, :product => product, :approved => false) }
  1.upto(approved.to_i) { Factory(:review, :product => product, :approved => true) }
  product.reviews.count.should == unapproved.to_i + approved.to_i
end

Then /^selectbox "(.+)" should be selected for "(.+)"$/ do |field, value|
  field_labeled(field).find(:xpath, ".//option[@selected = 'selected'][text() = '#{value}']").should be_present
end

Then /^I should see all (\d+) review for product "(.+)"$/ do |review_count, product_name|
  reviews = Product.find_by_name(product_name).reviews
  reviews.count.should == 6
  reviews.each do |review|
    find_by_id("review_number_review_#{review.id}").should have_content(review.review)
    if review.approved
      find_by_id("review_number_review_#{review.id}").find_link('Approve')
    end
  end
end


Then /^I should see all "(.+)" reviews$/ do |email|
  Review.by_products_owner(User.find_by_email(email)).each do |review|
    # It's simple way to know that this review in page )
    page.should have_content(review.ip_address)
  end
end

Given /^I have a unapproved review for "(.+)" and call it @review$/ do |product_name|
  @review = Factory(:review, :product => Product.find_by_name(product_name), :approved => false)
end

Then /^I apprved @review by click "(.+)"$/ do |approved_link|
  find_by_id("review_#{@review.id}").find_link(approved_link).click
end

Then /^I should not see @review on the product page$/ do
  page.should_not have_content(@review.review)
end

Then /^I should see @review on the reviews dashboard page$/ do
  page.should have_content(@review.ip_address)
end

Then /^I should see @review on the product page$/ do
  page.should have_content(@review.review)
end

Then /^I should not see link "(.+)"$/ do |link_name|
  page.should_not have_content(link_name)
end

Then /^I should see Baserd on some Rating$/ do
  page.should have_content("Based On #{Product.find_by_name('The Godfather').reviews_count} Ratings")
end
