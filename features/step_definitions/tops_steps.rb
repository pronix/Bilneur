Given /^I non register user$/ do
  Given %{I am logged out}
end

Given /^I should see given links in "(.+)"$/ do |div_class, table|
  table.hashes.each do |link|
    find(".#{div_class}").should have_link(link['link'], :href => path_to(link['href']))
  end
end
