Given /^the following groups:$/ do |groups|
  Groups.create!(groups.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) groups$/ do |pos|
  visit groups_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following groups:$/ do |expected_groups_table|
  expected_groups_table.diff!(tableish('table tr', 'td,th'))
end
