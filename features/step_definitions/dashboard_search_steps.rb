Then /^I should see all (\d+) product$/ do |count_of_product|
  Product.count.should == count_of_product.to_i
  Product.all.each { |product| page.should have_content(product.ean) }
end
