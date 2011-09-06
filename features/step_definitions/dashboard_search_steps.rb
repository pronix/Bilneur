Then /^I should see all (\d+) product$/ do |count_of_product|
  Product.count.should == count_of_product.to_i
  Product.all.each { |product| page.should have_content(product.ean) }
end

When /^request query should contain "(.+)"$/ do |search|
  page.driver.request.query_string.should == search
end

When /^I on the "(.+)" and press enter$/ do |field|
  find_field(field).native.send_key(:enter)
end

When /^I should see only "(.+)" from all products$/ do |product_name|
  Product.active.each do |product|
    page.should have_content(product.name) && next if product.name == product_name
    page.should_not have_content(product.name)
  end
end

When /^"(.+)" should has value "(.+)"$/ do |field, value|
  field_labeled(field).value.should == value
end

When /^"(.+)" should be selected "(.+)"$/ do |field, value|
  find_field(field).value.should == value
end

And /^I have quotes for each product$/ do
  Product.all.each { |product| Factory(:variant, :seller => @user, :owner => @user, :product => product) }
end

Given /^quote "(.+)" have warehouse is "(.+)"$/ do |name, warehouse|
  Variant.where(:product_id => Product.find_by_name(name).id, :is_master => false).last.update_attribute(:warehouse, warehouse)
end

Given /^I should see only these "(.+)" from all variants$/ do |quote|
  page.should have_content(quote)
end

Then /^I click by href "(.+)" link$/ do |href|
  find(:xpath, "//a[@href=\"#{href}\"]").click
end

Then /^I click by class "(.+)" link$/ do |some_class|
  find(".#{some_class}").find(:xpath, "//a").click
end

Given /^I have quotes for "(.+)" by seller "(.+)"$/ do |product_name, seller_email|
  user = User.find_by_email(seller_email)
  Factory(:variant, :seller => user, :owner => user, :product => Product.find_by_name(product_name))
end

Then /^I should see only "(.+)" by all product$/ do |product_name|
  my_product = Product.find_by_name(product_name)
  Product.all.each do |product|
    page.should have_content(product.name) && next if product == my_product
    page.should_not have_content(product.name)
  end
end

Then /^I click "(.+)" in class row by quote "(.+)"$/ do |link, product_name|
  variant = Variant.find_by_product_id(Product.find_by_name(product_name))
  find(".row#{variant.id}").find_link(link)
end

Then /^I click "(.+)" by dom_id variant for "(.+)" product$/ do |link, product_name|
  variant = Variant.find_by_product_id(Product.find_by_name(product_name))
  find_by_id("variant_#{variant.id}").find_link(link).click
end

Then /^I should have qutes by marked as "(.+)"$/ do |field|
  Variant.send(field.to_sym).present?.should == true
end




# Then /^I should see only "(.+)" by all product$/ do |quote|
#   quote = eval(quote)
#   Variant.active.each do |variant|
#     page.should have_content(variant.product.name) && next if variant == quote
#     page.should_not have_content(variant.product.name)
#   end
# end

