Taxon.class_eval do
  class << self
    def category
      roots.find_by_name("Categories")
    end
  end

  def as_json(options = {})
    super(options).merge({
      :root => self.root?,
      :leaf => self.leaf?,
    })
  end


end
