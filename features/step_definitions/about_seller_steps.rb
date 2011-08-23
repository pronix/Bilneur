Then /^I should see my about$/ do
  about = @user.about
  page.should have_content(about.you)
  page.should have_content(about.faq)
  page.should have_content(about.term)
end
