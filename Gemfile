source 'http://rubygems.org'

gem 'rails',                    '= 3.0.9'
gem 'bundler',                  '~> 1.0.15'
gem 'rack',                     '= 1.2.1'

gem 'pg',                       '~> 0.11.0'
gem "exception_notification",   '~> 2.4.1'


gem 'spree',                    '= 0.60.1'


# Spree extensons
# In rubygems only 0.60.1 version with bug.

 gem "spree_static_content",     :git => 'git://github.com/spree/spree_static_content.git', :tag => "v0.60.2"
 gem 'spree_editor',             '~> 0.50.1'
 gem 'spree_volume_pricing',     :path => 'vendor/spree_exts/spree_volume_pricing'
 # gem 'spree_additional_calculators', :git => "git://github.com/jurgis/spree-additional-calculators.git", :tag => "v0.1.1"
 gem 'spree_reviews',           :git => 'git://github.com/romul/spree-reviews.git'

 gem 'shop',                    :require => "shop", :path => "shop"

# Deploy with Capistrano
  gem 'capistrano'
  gem 'capistrano-ext'


# Use unicorn as the web server
gem 'unicorn', :group => :development


group :test, :cucumber do

  gem 'rspec-rails',          '= 2.6.1'
  gem 'factory_girl_rails',   '= 1.0.1'
  gem 'factory_girl',         '= 1.3.3'
  gem 'rcov'
  gem 'shoulda'

  gem 'cucumber',             "~> 1.0.2"
  gem 'cucumber-rails',       "~> 1.0.2"
  gem 'database_cleaner'
  gem 'capybara',             '~> 1.0.0'
  gem 'faker'
  gem 'launchy',              "~> 2.0.3"
  gem 'cucumber-websteps'
  gem 'email_spec',           "~> 1.2.1"
  gem 'selenium-webdriver',   '~> 0.2.2'
  gem "headless"
  gem "awesome_print"
  gem "wirble"
  gem "looksee"

  gem 'sqlite3'
  gem 'spork', '~> 0.9.0.rc', :require => false
  gem 'watchr', :require => false

  if RUBY_VERSION < "1.9"
    gem "ruby-debug"
  else
    gem "ruby-debug19"
  end


end

