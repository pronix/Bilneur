Given /^I am non auth user$/ do
  visit destroy_user_session_path
end

Then /^I should see given link with path$/ do |table|
  table.hashes.each do |hash|
    link = hash['options'].blank? ? path_to(hash['link_path']) : path_to(hash['link_path']) + '?' + hash['options']
    page.should have_xpath("//a[@href=\"#{link}\"]", :test => hash['link'])
  end
end
