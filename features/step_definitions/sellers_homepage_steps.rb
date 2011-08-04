Given /^I already sing as "(.+)\/(.+)" with "(.+)" role$/ do |email, password, role|
  Given %{I am signed up as "#{email}/#{password}"}
  User.find_by_email(email).set_seller_role!
  When %{I sign in as "#{email}/#{password}"}
end

Then /^I click "(.+)" link$/ do |link|
  find_link(link).click
end
