Given /^I non register user$/ do
  Given %{I am logged out}
end

Given /^I have "(\d+)" products with variant and "(\d+)" reviews$/ do |p_count, r_count|
  user = Factory.create(:user, :registration_as_seller => 1)
  1.upto(p_count.to_i) do
    product = Factory(:product, { :ean => "B004GVYJJ#{rand(99999)}", :owner => user})
    Factory(:variant, {:product => product, :seller => user, :condition => "used", :count_on_hand => 10})
    1.upto(r_count.to_i) do
      product.reviews.create(:name => 'test', :review => 'test', :approved => true, :rating => rand(5))
    end
  end
end

Given /^I recalculate rating for each product$/ do
  Product.all.each { |x| x.recalculate_rating }
end


Given /^I should see given links in "(.+)"$/ do |div_class, table|
  table.hashes.each do |link|
    find(".#{div_class}").should have_link(link['link'], :href => path_to(link['href']))
  end
end

Then /^I should see top products with big ratting$/ do
  Product.tops.limit(10).each do |product|
    page.should have_content(product.name)
    # Some test for product order. Product with higth avg_rating must be firs
    last_product = product and next if last_product.nil?
    (last_product.avg_rating.to_i >= product.avg_rating.to_i).should be true
    last_product = product
  end
end

Given /^I have "(\d+)" sellers user$/ do |count|
  1.upto(count.to_i) do |i|
    Factory.create(:user, :registration_as_seller => 1, :firstname => "First#{i}", :lastname => "Last#{i}")
  end
end

Then /^I should see "(\d+)" top sellers on the page$/ do |seller_count|
  User.sellers_top.limit(seller_count).each do |seller|
    page.should have_content(seller.firstname)
  end
end

Given /^I have "(\d+)" products with variant and random price$/ do |product_count|
  user = Factory.create(:user, :registration_as_seller => 1)
  1.upto(product_count.to_i) do
    product = Factory(:product, { :ean => "B004GVYJJ#{rand(99999)}", :owner => user, :price =>  rand(1000) + rand(100) / 100.0 })
    Factory(:variant, {:product => product, :seller => user, :condition => "used", :count_on_hand => 10})
  end
end

Then /^I should see "(\d+)" top deals on th page$/ do |product_count|
  Product.top_deals.limit(10).each do |product|
    page.should have_content(product.name)
  end
end
