Given /^I user has order with "([^\"]*)" product$/ do |product_name|
  address = Factory(:address)
  variant = Product.find_by_name(product_name).variants.last
  @order = Factory(:order, :user => @user, :bill_address => address, :ship_address => address)
  line_item = Factory(:line_item, :order => @order, :variant => variant)
end

Given /^I add "(.+)" shipment for order$/ do |shipment_name|
  @order.shipping_methods << ShippingMethod.find_by_name(shipment_name)
  @order.create_shipment!
  @order.payment
end

Then /^change order to paid$/ do
  Order.last.payments.each { |v|
    v.payment_source.send(:capture, v)
  }
end

Then /^change order to shipped$/ do
  Order.last.shipments.each { |v|
    v.send("ship")
  }
end

Then /^create seller review and receiving$/ do
  seller = User.find_by_email('seller1@person.com')
  a = SellerReview.build(Order.last, @user, seller, :review => 'adsadsads', :rating => 3)
  a.save
  Order.last.shipments.each { |v|
    v.send("receiving")
  }
  puts a.errors
  puts SellerReview.last.to_a
end

Given /^I have order$/ do
  address = Factory(:address)
  variant = Product.find_by_name('The Godfather').variants.last
  @order = Factory(:order, :user => @user, :bill_address => address, :ship_address => address)
  line_item = Factory(:line_item, :order => @order, :variant => variant)
  4.times { @order.send('next') }
end

Then /^I should see my order$/ do
  @user.orders.each { |order| page.should have_content(order.number)}
end

Given /^I review seller "(.+)" with my order, review "(.+)", rating "(\d+)"$/ do |seller, review, rating|
  SellerReview.create(:seller => User.find_by_email(seller), :buyer => @user, :order => @order, :review => review, :rating => rating )
end

Then /^I should see my rating for "(.+)"$/ do |seller_email|
  review = @order.seller_reviews.where(:seller_id => User.find_by_email(seller_email).id).last
  find_by_id("seller_review_#{review.id}").should  have_xpath("//img[contains(@src, \"yel_str.png\")]", :count => review.rating)
end

Then /^I should see "(.+)" fullname$/ do |user|
  page.should have_content(User.find_by_email(user).full_name)
end
