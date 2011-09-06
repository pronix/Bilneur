Given /^I have order by following values and product "(.+)":$/ do |product_name, table|
  address = Factory(:address)
  variant = Product.find_by_name(product_name).variants.last
  table.hashes.each do |hash|
    minus_time = eval(hash[:created_at])
    order = Factory(:order, :user => @user, :bill_address => address, :ship_address => address, 
            :created_at => Time.now - minus_time, :number => hash[:number])
    line_item = Factory(:line_item, :order => order, :variant => variant)
    4.times { order.send('next') }
  end
end

Then /^I should see all my orders$/ do
  @user.orders.each { |order| page.should have_content(order.number) }
end

Then /^I should see only order with number "(.+)"$/ do |order_number|
  my_order = Order.find_by_number(order_number)
  @user.orders.each do |order|
    page.should have_content(order.number) and next if order == my_order
    page.should_not have_content(order.number)
  end
end
