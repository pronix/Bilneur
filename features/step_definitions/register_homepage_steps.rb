Then /^I follow Start Selling link as have role "(.+)"$/ do |role|
  if role == 'user'
    link = path_to('account page') + '?' + 'as_seller=true'
  end
  find(:xpath, "//a[@href=\"#{link}\"]").click
end

Then /^user "(.+)" should have a "(.+)" role$/ do |user_email, role_name|
  User.find_by_email(user_email).has_role?(role_name).should be_true
end
