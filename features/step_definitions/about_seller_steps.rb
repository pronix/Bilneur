Then /^I should see my about$/ do
  about = @user.static_data
  page.should have_content(about.about)
  page.should have_content(about.faq)
  page.should have_content(about.term)
end

Then /^I should se my rerun policy$/ do
  page.should have_content(@user.static_data.return_policy)
end
