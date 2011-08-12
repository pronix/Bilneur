 When /^I set quatility "([^\"]*)"$/ do |quatility|
    find("input[type='text']:first").set(quatility.to_i)
 end
