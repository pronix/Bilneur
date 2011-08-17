Calculator::PriceBucket.class_eval do

  # as object we always get line items, as calculable we have Coupon, ShippingMethod
  def compute(object, *args)
    if object.is_a?(Array)
      base = object.map{ |o| o.respond_to?(:amount) ? o.amount : o.to_d }.sum
    else
      base = object.respond_to?(:amount) ? object.amount : object.to_d
    end

    if base >= self.preferred_minimal_amount
      self.preferred_normal_amount
    else
      self.preferred_discount_amount
    end
  end



end
