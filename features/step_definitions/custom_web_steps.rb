
# When /^I delete the (\d+)(?:st|nd|rd|th) products$/ do |pos|
#   visit products_path
#   within("table tr:nth-child(#{pos.to_i+1})") do
#     click_link "Destroy"
#   end
# end

# Then /^I should see the following products:$/ do |expected_products_table|
#   expected_products_table.diff!(tableish('table tr', 'td,th'))
# end
