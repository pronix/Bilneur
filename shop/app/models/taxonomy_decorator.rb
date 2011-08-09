Taxonomy.class_eval do
  class << self
    def category
      where(:name => "Categories").includes(:root => :children).first
    end
  end
end
