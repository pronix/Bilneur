Given /^I have (\d+) orders for "(.+)"$/ do |count_orders, product_name|
  address = Factory(:address)
  variant = Product.find_by_name(product_name).variants.last
  1.upto(count_orders.to_i) do
    @order = Factory(:order, :user => @user, :bill_address => address, :ship_address => address, :created_at => Time.now - rand(10).days)
    line_item = Factory(:line_item, :order => @order, :variant => variant)
    4.times { @order.send('next') }
  end
end

Then /^I should see (\d+) orders on the page$/ do |order_count|
  Order.count.should == order_count.to_i
  Order.all.each { |order| page.should have_content(order.number) }
end

Then /^I fill in "(.+)" with @order\.number$/ do |field|
  fill_in(field, :with => @order.number)
end

# Show only @order in the page
Then /^I should see only @order on the page$/ do
  Order.all.each { |order| order == @order ? page.should(have_content(order.number)) : page.should_not(have_content(order.number)) }
end

Then /^I should get a download with content-type "(.+)"$/ do |content_type|
  page.response_headers['Content-Type'].should == content_type
end
