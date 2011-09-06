source 'http://rubygems.org'

gem 'rails',                    '= 3.0.9'
gem 'bundler',                  '~> 1.0.15'
gem 'rack',                     '= 1.2.2'
gem 'nokogiri',                 '~> 1.5.0'
gem 'thrift_client',            '~> 0.6.3'
gem 'json',                     '~> 1.5.3'
gem 'json_pure',                '~> 1.5.3'
gem 'ancestry',                 '~> 1.2.3'
gem "gherkin",                  "= 2.4.6"
gem 'pg',                       '~> 0.11.0'
gem 'sqlite3'

gem 'exception_notification',   '~> 2.4.1'
gem 'whenever',               "~> 0.6.8", :require => false

gem "thinking-sphinx", "= 2.0.5"
gem "thinking-sphinx-raspell", "= 1.1.1"


gem 'spree',                    '= 0.60.1'

# Deploy with Capistrano
  gem 'capistrano'
  gem 'capistrano-ext'



# Spree extensons
# In rubygems only 0.60.1 version with bug.
 gem "spree_paypal_express", :git => "git://github.com/spree/spree_paypal_express.git"
 gem 'spree_static_content',     :git => 'git://github.com/spree/spree_static_content.git', :tag => 'v0.60.2'
 gem 'spree_editor',             '~> 0.50.1'
 gem 'spree_volume_pricing',     :path => 'vendor/spree_exts/spree_volume_pricing'
 gem 'spree_reviews',            :git => 'git://github.com/romul/spree-reviews.git'
 gem 'spree_social',             :path => 'vendor/spree_exts/spree_social'
 gem 'spree_address_book',       :path => 'vendor/spree_exts/spree_address_book'
 gem 'spree_print_invoice',      :path => 'vendor/spree_exts/spree-print-invoice'
 gem "spree_sphinx_search",      :path => 'vendor/spree_exts/spree-sphinx-search'
 gem 'shop',                    :require => 'shop', :path => 'shop'



group :development do
  gem 'unicorn'
  gem "silent-postgres", "~> 0.0.8"
end

group :test, :cucumber do
  gem "show_me_the_cookies", '~> 0.2.2', :git => "git://github.com/nruth/show_me_the_cookies.git"
  gem "silent-postgres", "~> 0.0.8"
  gem 'rspec-rails',          '= 2.6.1'
  gem 'factory_girl_rails',   '= 1.0.1'
  gem 'factory_girl',         '= 1.3.3'
  gem 'rcov'
  gem 'shoulda'

  gem 'cucumber',             '~> 1.0.2'
  gem 'cucumber-rails',       '~> 1.0.2'
  gem 'database_cleaner'
  gem 'capybara',             '~> 1.0.1'
  gem 'faker'
  gem 'launchy',              '~> 2.0.3'
  gem 'cucumber-websteps'
  gem 'email_spec',           '~> 1.2.1'
  gem 'selenium-webdriver',   '~> 2.5.0'
  gem 'headless'
  gem 'awesome_print'
  gem 'wirble'
  gem 'looksee',              '= 1.0.2'
  gem "childprocess", "~> 0.2.1"

  gem 'sqlite3'
  gem 'spork', '~> 0.9.0.rc', :require => false
  gem 'watchr', :require => false

  if RUBY_VERSION < '1.9'
    gem 'ruby-debug'
  else
    gem 'ruby-debug19'
  end


end

