Then /^I open "(.+)"$/ do |url|
  visit url
end

Then /^access to "(.+)" must be "(.+)"$/ do |page_url, access|
  case access
    when "allowed"
      assert_equal page_url, current_path
    when "denied"
      current_path.should_not == page_url
  end
end
