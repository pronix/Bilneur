require 'spree_core'
require 'shop_hooks'

module Shop
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      path_constants = File.join(File.dirname(__FILE__), "../config/initializers/shop_constant.rb")
      Rails.env.production? ? require(path_constants) : load(path_constants)

      if Product.table_exists?
        Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
          Rails.env.production? ? require(c) : load(c)
        end
      end

      Dir.glob(File.join(File.dirname(__FILE__), "../app/models/calculator/**/*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end

      Calculator::WeightRate.register

    end

    config.to_prepare &method(:activate).to_proc

  end
end
