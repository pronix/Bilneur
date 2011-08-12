 When /^I set quatility "([^\"]*)"$/ do |quatility|
    find("input[type='text']:first").set(quatility.to_i)
 end
When /^I choose "([^\"]*)" from Shipping Methods$/ do |method_name|
   method =  ShippingMethod.find_by_name(method_name)
   When %Q(I choose "order_shipping_method_id_#{method.id}")
end
