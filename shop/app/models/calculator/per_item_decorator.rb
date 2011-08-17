Calculator::PerItem.class_eval do

  def compute(object=nil, *args)
    @seller = self.calculable.seller if self.calculable && self.calculable.respond_to?(:seller)
    if @seller
      self.preferred_amount * object.line_items.select{ |v| v.variant.seller == @seller }.length
    else
      self.preferred_amount * object.line_items.length
    end

  end

end
