Given /^I non register user$/ do
  Given %{I am logged out}
end

Given /^I have "(\d+)" products with variant and "(\d+)" reviews$/ do |p_count, r_count|
  1.upto(p_count.to_i) do
    product = Factory(:product_with_variant, :owner => Factory(:seller_user_with_shipping) )
    1.upto(r_count.to_i) { Factory(:review, :approved => true, :product => product)}
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

Given /^I have "(\d+)" sellers user with different reviews$/ do |count|
  1.upto(count.to_i) do
    user = Factory(:seller_user)
    1.upto(rand(10)) do
      Factory(:seller_review, :seller => user)
    end
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
  1.upto(product_count.to_i) { Factory(:product_with_variant, :owner => Factory(:seller_user_with_shipping), :price => (rand(1000) + rand(100) / 100.0) + 1 ) }
end

Then /^I should see "(\d+)" top deals on th page$/ do |product_count|
  Product.top_deals.limit(10).each do |product|
    page.should have_content(product.name)
  end
end
