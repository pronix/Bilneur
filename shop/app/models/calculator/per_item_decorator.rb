Calculator::PerItem.class_eval do

  def compute(object=nil, *args)
    if self.calculable && self.calculable.seller
      self.preferred_amount * object.line_items.select{ |v| v.variant.seller == self.calculable.seller }.length
    else
      self.preferred_amount * object.line_items.length
    end

  end

end
