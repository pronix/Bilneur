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
