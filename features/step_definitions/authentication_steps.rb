Given /^I am logged out$/ do
  begin
    click_link("Logout")
  rescue Capybara::ElementNotFound
  end
end

Then /^I should be logged in$/ do
  page.should_not have_content("Log In")
  page.should have_content("Logout")
end

Then /^I should be logged out$/ do
  page.should have_content("Log In")
end

Given /^I am signed up as "(.+)\/(.+)"$/ do |email, password|
  @user = Factory(:user, :email => email, :password => password, :password_confirmation => password)
end

Given /^I have an admin account of "(.+)\/(.+)"$/ do |email, password|
  Factory(:admin_user,  :email => email, :password => password, :password_confirmation => password)
end

When /^I sign in as "(.*)\/(.*)"$/ do |email, password|
  When %{I go to the sign in page}
  And %{I fill in "Email" with "#{email}"}
  And %{I fill in "Password" with "#{password}"}
  And %{I press "Log In"}
end

if defined? CanCan::Ability
  class AbilityDecorator
    include CanCan::Ability

    def initialize(user)
      cannot :manage, Order
    end
  end
end

Given /^I do not have permission to access orders$/ do
  Ability.register_ability(AbilityDecorator)
end

Then /^a password reset message should be sent to "(.*)"$/ do |email|
  user = User.find_by_email(email)
  assert !user.reset_password_token.blank?
  assert !ActionMailer::Base.deliveries.empty?
  result = ActionMailer::Base.deliveries.any? do |email|
    email.to == [user.email] &&
    email.subject =~ /password/i &&
    email.body =~ /#{user.reset_password_token}/
  end
  assert result
end

Given /^I requested password reset$/ do
  @user.send_reset_password_instructions
end

When /^I follow the password reset link$/ do
  visit(edit_user_password_path(:reset_password_token => @user.reset_password_token))
  Then %{I should see "Change my password"}
end

Given /^I try to auth with "(.+)" and "(.+)"$/ do |email, password|
  And %{I am on the sign in page}
  And %{I fill in "Email" with "#{email}"}
  And %{I fill in "Password" with "#{password}"}
  And %{press "Log In"}
end

Given /^I already sing as "(.*)\/(.*)"$/ do |email, password|
  Given %{I am signed up as "#{email}/#{password}"}
  Given %{I try to auth with "#{email}" and "#{password}"}
end


Given /^I should see given in page$/ do |table|
  table.hashes.each do |hash|
    page.should have_content(hash['element'])
  end
end

Given /^I ask a password with valid credentials$/ do
  Given %{I am signed up as "email@person.com/password"}
  And %{I am on the sign in page}
  Then %{I follow "Forgot Password?"}
  When %{I fill in "user_email" with "email@person.com"}
  And %{press "Reset my password"}
  Then %{I should see "You will receive an email with instructions about how to reset your password in a few minutes."}
end
