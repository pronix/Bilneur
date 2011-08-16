When /^I set quatility "([^\"]*)"$/ do |quatility|
  find("input[type='text']:first").set(quatility.to_i)
end


When /^I choose "([^\"]*)" from seller "([^\"]*)" Shipping Methods$/ do |method_name, email|
  user = User.find_by_email(email)
  method =  user.shipping_methods.find_by_name(method_name)
  When %Q(I choose "order_shipping_method_id_#{method.id}")
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
