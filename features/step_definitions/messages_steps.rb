When /^"([^\"]*)" has my message in the Sent$/ do |email|
  user = User.find_by_email(email)
  user.sent.count.should eq(1)
end

When /^user "([^\"]*)" has my message in the Received tab$/ do |email|
  user = User.find_by_email(email)
  user.inbox.count.should eq(1)
end
Then /^the page should have the following messages:$/ do |table|
  table.diff!(tableish('table:first tr', 'td,th'))
end

Then /^the page should have text area for reply$/ do
  page.should have_selector('textarea#message_content')
end

