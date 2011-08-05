Given /^I already sing as "(.+)\/(.+)" with "(.+)" role$/ do |email, password, role|
  Given %{I am signed up as "#{email}/#{password}"}
  user = User.find_by_email(email)
  # Becouse if we use this test first, spree automatic add first user to admin
  user.roles << Role.find_or_create_by_name(role) if ! user.has_role?(role)
  When %{I sign in as "#{email}/#{password}"}
end

Then /^I click "(.+)" link$/ do |link|
  find_link(link).click
end
