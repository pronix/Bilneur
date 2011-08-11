When /^I confirm popup$/ do
  page.driver.browser.switch_to.alert.accept
end

When /^I dismiss popup$/ do
  page.driver.browser.switch_to.alert.dismiss
end

Given /^load default data$/ do
  fixtures_dir = File.expand_path("#{Rails.root}/db/default")
  Fixtures.reset_cache
  Fixtures.create_fixtures(fixtures_dir, ['countries', 'states', 'zones', 'zone_members'])

end
