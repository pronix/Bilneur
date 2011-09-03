Then /^I follow "(.+)" in the class "(.+)"$/ do |link, class_name|
  find(".#{class_name}").find_link(link).click
end

Then /^I follow new volume price with given values:$/ do |table|
  table.hashes.each do |hash|
    hash.each { |field, value| fill_in(/variant_volume_prices_attributes_\d+_display/, :with => value) }
  end
  # puts table.inspect
  # table.hashes.each { |hash| And %{I fill in "variant_volume_prices_attributes_0_display#{}" with ""} }
end
