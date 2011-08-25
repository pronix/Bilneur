When /^I set quatility "([^\"]*)"$/ do |quatility|
  find("input[type='text']:first").set(quatility.to_i)
end


When /^I choose "([^\"]*)" from seller "([^\"]*)" Shipping Methods$/ do |method_name, email|
  user = User.find_by_email(email)
  method =  user.shipping_methods.find_by_name(method_name)
  # When %Q(I choose "order_shipping_method_id_#{method.id}")

  page.execute_script <<-JS
    $('#order_shipping_method_id_#{method.id}').attr('checked', true);
  JS
end

Then /^seller "([^\"]*)" should have new virtual order in sales with shipment state "([^\"]*)"$/ do |email, shipping_state|
  @user = User.find_by_email email
  @user.virtual_sales.complete.count.should eq(1)
  @user.virtual_sales.complete.first.shipment_state.should eq(shipping_state)
end

Then /^buyer "([^\"]*)" should see orders in orders with shipment state "([^\"]*)"$/ do |email, shipping_state|
  @user = User.find_by_email email
  @user.virtual_orders.complete.each do |item|
    item.shipment_state.should eq(shipping_state)
  end

end

When /^seller "([^\"]*)" set shipment status as "([^\"]*)"$/ do |email, state|
  @user = User.find_by_email email
  @user.virtual_sales.complete.each do |item|
    item.shipments.where(:seller_id => @user.id).each do |v|
      v.send("#{state}")
    end
  end
end

When /^buyer "([^\"]*)" paid orders$/ do |email|
  @user = User.find_by_email email
  @user.virtual_orders.complete.each do |item|
    item.payments.each { |v|
      v.payment_source.send(:capture, v)
    }
  end
end
Then /^seller "([^\"]*)" should see the following quotes in dashboard:$/ do |email, table|
  @user = User.find_by_email email
  table.hashes.each do |item|
    @product = Product.find_by_name(item["product_name"])
    @quote = @product.variants.where(:seller_id => @user.id).first
    @quote.count_on_hand.should eq(item["count_on_hand"].to_i)
  end
end


Then /^user "([^\"]*)" should see the following quotes in dashboard:$/ do |email, table|
  @user = User.find_by_email email
  table.hashes.each do |item|
    @product = Product.find_by_name(item["product_name"])
    @quote = @user.quotes.virtual.where(:product_id => @product.id).first
    @quote.should be_present
    @quote.count_on_hand.should eq(item["count_on_hand"].to_i)
    @quote.price.to_f.should eq(item["price"].to_f)
    @quote.condition.to_s.should eq(item["condition"])
  end

end

Given /^the user "([^\"]*)" has the order with number "([^\"]*)" and date "([^\"]*)":$/ do |email, number, date, table|
  @user  = User.find_by_email email
  @order = Factory(:order, :number => number, :created_at => Time.parse(date), :user => @user)

  table.hashes.each do |item|
    @seller  = User.find_by_email(item["seller"])
    @product = Product.find_by_name(item["product"])
    @quote  = @product.variants.find_by_seller_id(@seller.id)
    Factory(:line_item, :order => @order, :variant => @quote, :quantity => item["quantity"], :price => item["price"] )
  end
  @order.state = "complete"
  @order.completed_at = Time.parse(date)
  @order.save!

end

When /^I select first shipping address$/ do
  When %Q(I choose "order[ship_address_id]")
end



Then /^page not have Saved Items panel$/ do
  page.should have_no_content('Your Saved Items')
end
Then /^page have Saved Items panel with the following products:$/ do |table|
  table.raw.each do |r|
    within("#your_saved_items") do
      page.should have_content(r[0])
    end
  end
end

Then /^the cart include the product "([^\"]*)" with quantity "([^\"]*)"$/ do |product_name, quantity|
  within("#normal-cart") do
    page.should have_content(product_name)
    find_field("order_line_items_attributes_0_quantity").value.should eq(quantity)
  end
end

Then /^the virtual cart include the product "([^\"]*)" with quantity "([^\"]*)"$/ do |product_name, quantity|
  within("#virtual-cart") do
    page.should have_content(product_name)
    find_field("order_line_items_attributes_0_quantity").value.should eq(quantity)
  end
end
