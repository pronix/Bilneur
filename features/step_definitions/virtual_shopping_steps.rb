When /^I set quatility "([^\"]*)"$/ do |quatility|
  find("input[type='text']:first").set(quatility.to_i)
end


When /^I choose "([^\"]*)" from Shipping Methods$/ do |method_name|
  method =  ShippingMethod.find_by_name(method_name)
  When %Q(I choose "order_shipping_method_id_#{method.id}")
end

Then /^seller "([^\"]*)" should have new virtual order in sales with shipment state "([^\"]*)"$/ do |email, shipping_state|
  @user = User.find_by_email email
  @user.virtual_sales.complete.count.should eq(1)
  @user.virtual_sales.complete.first.shipment_state.should eq(shipping_state)
end

Then /^buyer "([^\"]*)" should see new order in orders with shipment state "([^\"]*)"$/ do |email, shipping_state|
  @user = User.find_by_email email
  @user.virtual_orders.complete.count.should eq(1)
  @user.virtual_orders.complete.first.shipment_state.should eq(shipping_state)
end

When /^seller "([^\"]*)" set shipment status as "([^\"]*)"$/ do |email, state|
  @user = User.find_by_email email
  @order = @user.virtual_sales.complete.first
  @shipment = @order.shipments.first
  @shipment.send("#{state}!")
  @order.inspect
end

When /^buyer "([^\"]*)" paid orders$/ do |email|
  @user = User.find_by_email email
  @order = @user.virtual_orders.complete.first
  @payment = @order.payments.first
  @payment.payment_source.send("capture", @payment)

end
Then /^seller "([^\"]*)" should see the following quotes in dashboard:$/ do |email, table|
  @user = User.find_by_email email
  table.hashes.each do |item|
    @product = Product.find_by_name(item["product_name"])
    @quote = @product.variants.where(:seller_id => @user.id).first
    @quote.count_on_hand.should eq(item["count_on_hand"].to_i)
  end
end
