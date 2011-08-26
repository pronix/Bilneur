Calculator::FlatRate.class_eval do

  def compute(object=nil, *args)
    self.preferred_amount
  end

  # Compute shipping for one variant
  #
  def compute_for_one_variant(variant=nil)
    self.preferred_amount
  end
end
