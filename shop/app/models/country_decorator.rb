Country.class_eval do
  default_scope order("name")
  class << self
    def default
      find(Spree::Config[:default_country_id])
    end
  end
end
