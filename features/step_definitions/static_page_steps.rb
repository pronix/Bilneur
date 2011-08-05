Given /^I have static page "(.+)\/(.+)\/(.+)"$/ do |title, url, body|
  When %{I go to the new admin static page}
  And %{I fill in "Title" with "#{title}"}
  And %{I fill in "Slug" with "#{url}"}
  And %{I fill in "Body" with "#{body}"}
  And %{press "Create"}
end

Then /^I visit "(.+)"$/ do |url|
  visit url
end
