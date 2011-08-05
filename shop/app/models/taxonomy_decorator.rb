Taxonomy.class_eval do
  class << self
    def categories
      where(:name => "Categories").includes(:root => :children)
    end
  end
end
