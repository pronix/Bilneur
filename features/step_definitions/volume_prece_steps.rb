Then /^I follow "(.+)" in the class "(.+)"$/ do |link, class_name|
  find(".#{class_name}").find_link(link).click
end

# DO_NOT_FORGET!
Then /^I follow new volume price with given values:$/ do |table|
  table.hashes.each do |hash|
    hash.each do |last_hash|
      find(:xpath, "//*[contains(@id,\"_#{last_hash[0]}\")]").set(last_hash[1])
    end
  end
end

Then /^I should have volume price with given values:$/ do |table|
  volume_price = VolumePrice.last
  table.hashes.each do |hash|
    hash.each do |last_hash|
      volume_price.send(last_hash[0].to_sym).to_s.should == last_hash[1]
    end
  end
end

Then /^I should see given tables:$/ do |table|
  table.hashes.each { |hash| find_by_id(hash[:field]).value.should == hash[:value] }
end

Given /^I have volume price for @quote$/ do
  @volume_price = Factory(:volume_price, :variant => @quote)
end

Given /^I have volume price for @quote with given value:$/ do |table|
  table.hashes.each { |hash| Factory(:volume_price, :variant => @quote, :start_range => hash[:start_range], :end_range => hash[:end_range])}
end

Then /^I change some given values:$/ do |table|
  table.hashes.each do |hash|
    hash.each {|field, value| find(:xpath, "//*[contains(@id,\"_#{field}\")]").set(value) }
  end
end
