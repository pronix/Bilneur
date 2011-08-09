Taxon.class_eval do
  class << self
    def category
      roots.find_by_name("Categories")
    end
  end
end
