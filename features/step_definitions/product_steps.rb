Then /puts products/ do
  puts Product.all.inspect
end
Given /^products is not exists$/ do
  # Product.destroy_all
end

Given /^the product "([^\"]*)" has the owner "([^\"]*)"$/ do |product_name, email|
  Product.find_by_name(product_name).update_attribute(:owner, User.find_by_email(email))
end

Then /^I should see the following product lists:$/ do |table|
  table.diff!(tableish('table tr', 'td,th'))
end



# Given /^(?:|I )have the following products:$/ do |table|

#   table.hashes.each do |r|
#     @taxon = Taxon.find_by_name r["taxon"]
#     @product = Factory.create(:product, :name => r["name"], :taxons => [@taxon], :ean => r["ean"] )
#   end

# end

# Given /^the product "([^\"]*)" have the following quotes:$/ do |product_name, table|
#   @product = Product.find_by_name(product_name)
#   table.hashes.each do |row|
#     @variant = Factory.create(:variant,
#                               :seller_id => User.find_by_email(row["seller"]).id,
#                               :price => row["price"], :count_on_hand => row["count_on_hand"], :product => @product )
#   end
# end

# Then /^(?:|I )should see products list:$/ do |table|
#   table.diff!(tableish('table#listing_products tr', 'td,th'))
# end

# Given /^the product "([^\"]*)" have the image "([^\"]*)"$/ do |product_name, image_path|
#   @product = Product.find_by_name(product_name)
#   @product.images << Image.new(:attachment => File.open("#{Rails.root}/spec/data/#{image_path}"))
# end


# Then /^(?:|I )should see the following quotes on the product "([^\"]*)":$/ do |product_name, table|
#   @product = Product.find_by_name(product_name)
#   table.hashes.each do |r|
#     with_scope("listing_quotes"){
#       @seller = User.find_by_email(r["seller"])
#       When %Q(I should see "#{@seller.full_name}")
#       And %Q(I should see "#{r["price"]}")
#     }
#   end
# end

# Then /^(?:|I )should not see the following quotes on the product "([^\"]*)":$/ do |product_name, table|
#   @product = Product.find_by_name(product_name)
#   table.hashes.each do |r|
#     with_scope("listing_quotes"){
#       @seller = User.find_by_email(r["seller"])
#       When %Q(I should not see "#{@seller.fullname}")
#       And %Q(I should not see "#{r["price"]}")
#     }
#   end
# end


# Given /^the have following product properties:$/ do |table|
#   table.hashes.each do |row|
#     Factory(:property, row)
#   end
# end

# Given /^the product "([^\"]*)" has the following properties:$/ do |product_name, table|
#   @product = Product.find_by_name product_name
#   table.hashes.each do |row|
#     @product.product_properties.create({ :property => Property.find_by_name(row["name"]), :value => row["value"] })
#   end
#   @product.save

# end

# Then /^(?:|I )should see a product properties$/ do |table|
#   table.hashes.each do |row|
#     find("#product-properties").find("dt", :text => row["name"]).should be_present
#     find("#product-properties").find("dd", :text => row["value"]).should be_present
#   end
# end

