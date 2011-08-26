Given /^no user exists with an email of "(.*)"$/ do |email|
  User.find_by_email(email).should be_nil
end

Then /^(\d+) users should exist$/ do |c|
  User.count.should == c.to_i
end

Given /^an anonymous user has been created$/ do
  User.anonymous!
end

Then /^"([^\"]*)" should have role "([^\"]*)"$/ do |email, role|
  User.find_by_email(email).has_role?(role).should be_true
end

Given /^user "([^\"]*)" has the following attributes:$/ do |email, table|
  user = User.find_by_email email
  user.update_attributes(table.rows_hash)
end

Then /^page should have the following addresses:$/ do |table|
  table.diff!(tableish('table.order-summary:first tr', 'td,th'))
end

Given /^user "([^\"]*)" have the following addresses:$/ do |email, table|
  user = User.find_by_email email
  table.raw.each do |r|
    attr = r.to_s.split(',')
    Factory(:address,{ :zipcode => attr[0].strip,
              :firstname => user.firstname, :lastname => user.lastname,
              :country => Country.find_by_name(attr[1].strip),
              :state => State.find_by_name(attr[2].strip),
              :city => attr[3].strip,
              :address1 => attr[4].strip,
              :user => user, :address2 => ""
            })
  end
end

Then /^page have the following payment methods:$/ do |table|
  table.diff!(tableish('table:first tr', 'td,th'))
end

Given /^user "([^\"]*)" has no payment methods$/ do |user|
  @user = User.find_by_email(user)
  @user.seller_payment_methods.destroy_all
end

Given /^the following sellers exist:$/ do |table|
  table.hashes.each do |item|
    @user = Factory(:user, item.merge({ :registration_as_seller => 1}) )
    Factory(:seller_payment_method, {:user_id => @user.id})
  end
end


Given /^seller "([^\"]*)" has the following virtual shipping methods exist:$/ do |email, table|
  @seller = User.find_by_email email
  table.hashes.each_with_index do |item, i|

    q = Factory(:calculator, {
                  :type => "Calculator::FlatRate",
                  :calculable_id => Factory.next(:shipping_calculable_sequence),
                  :calculable_type => "ShippingMethod"})
    q.set_preference(:amount, 0.0)

    Factory.create(:shipping_method, {
              :name => item["name"],
              :seller => @seller,
              :virtual => (item["virtual"].to_s =~ /true/i ? true : false ),
              :calculator => q
            })

  end
end

Then /^the page have the following purchases list:$/ do |table|

  table.hashes.each_with_index do |r, i|
    @order = Order.find_by_number(r["order_number"])
    @product = Product.find_by_name(r["product"])
    @item = @order.line_items.detect{ |v| v.product == @product }
    within("#item_#{@item.id}") do
      Then %Q(I should see "#{r['product']}")
      Then %Q(I should see "#{r['seller']}")
      Then %Q(I should see "#{r['order_date']}")
      Then %Q(I should see "#{r['order_number']}")
      Then %Q(I should see "#{r['amount']}")
    end
  end
end

Then /^I should see following address in page$/ do |table|
  table.hashes.each do |hash|
    hash[:address].split(',').each { |need_find| page.should have_content(need_find) }
  end
end

Then /^address should be primary$/ do
  @user.addresses.last.primary.should be_true
end
