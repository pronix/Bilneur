require 'cucumber/rails'
require 'email_spec/cucumber'
require 'cucumber/thinking_sphinx/external_world'
# When we use some quick test without sphinx
Cucumber::ThinkingSphinx::ExternalWorld.new if ENV['NO_SPHINX'].nil?

# require 'spree_core/testing_support/factories'

# require File.expand_path('vendor/spree-exts/spree-0.60.1/spree_core/../features/support/env', __FILE__)
# require 'spree_core/testing_support/factories'

Spree::Auth::Config.set(:registration_step => true)
Spree::Auth::Config.set(:signout_after_password_change => false)
# sometimes tests fail randomly because cache is not refreshed, fixed that
Spree::Config.set(:foo => "bar")
Spree::Config.set(:auto_caprure => false)
# Spree::Reviews::Config.set(:require_login => true)

# Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
# order to ease the transition to Capybara we set the default here. If you'd
# prefer to use XPath just remove this line and adjust any selectors in your
# steps to use the XPath syntax.
Capybara.default_selector = :css

# By default, any exception happening in your Rails application will bubble up
# to Cucumber so that your scenario will fail. This is a different from how
# your application behaves in the production environment, where an error page will
# be rendered instead.
#
# Sometimes we want to override this default behaviour and allow Rails to rescue
# exceptions and display an error page (just like when the app is running in production).
# Typical scenarios where you want to do this is when you test your error pages.
# There are two ways to allow Rails to rescue exceptions:
#
# 1) Tag your scenario (or feature) with @allow-rescue
#
# 2) Set the value below to true. Beware that doing this globally is not
# recommended as it will mask a lot of errors for you!
#
ActionController::Base.allow_rescue = false

Capybara.save_and_open_page_path = File.join(Rails.root, "tmp")
# Remove/comment out the lines below if your app doesn't have a database.
# For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

# You may also want to configure DatabaseCleaner to use different strategies for certain features and scenarios.
# See the DatabaseCleaner documentation for details. Example:
#
#   Before('@no-txn,@selenium,@culerity,@celerity,@javascript') do
#     DatabaseCleaner.strategy = :truncation, {:except => %w[widgets]}
#   end
#
#   Before('~@no-txn', '~@selenium', '~@culerity', '~@celerity', '~@javascript') do
#     DatabaseCleaner.strategy = :transaction
#   end
#
if ENV['HEADLESS'] == 'true'
  require 'headless'
  headless = Headless.new
  headless.start
  at_exit do
    headless.destroy
  end
end


require 'factory_girl/step_definitions'

Before('@facebook') do
  require 'oa-core'
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:facebook] = {
    'uid' => '111xxx222yyy333zzz',
    'provider'   => 'facebook',
    'link'       => 'http://facebook.com/bubbleboy',
    'email'      => 'boy@bubble.com',
    'first_name' => 'User',
    'last_name'  => 'Name',
    'user_info'  => {
      'nickname' => "bob"
    }
  }

  authentication_method = AuthenticationMethod.create!(:environment => "test", :active => true)
  Preference.create! :owner => authentication_method, :name => "provider", :value => "facebook"
  Preference.create! :owner => authentication_method, :name => "enable_authentication_method", :value => true
end

World(ShowMeTheCookies)
Before('@announce') do
  @announce = true
end

def dom_id(var)
  "#{var.class.to_s.downcase}_#{var.id}"
end
