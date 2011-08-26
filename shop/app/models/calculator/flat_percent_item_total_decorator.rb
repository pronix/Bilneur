Calculator::FlatPercentItemTotal.class_eval do

  def compute(object, *args)
    return unless object.present? and object.line_items.present?
    @seller = self.calculable.seller if self.calculable && self.calculable.respond_to?(:seller)

    item_total = ( @seller ? object.line_items.select{ |v| v.variant.seller == @seller } : object.line_items ).map(&:amount).sum
    value = item_total * self.preferred_flat_percent / 100.0
    (value * 100).round.to_f / 100
  end

  # Compute shipping for one variant
  #
  def compute_for_one_variant(variant)
    value = variant.price * self.preferred_flat_percent / 100.0
    (value * 100).round.to_f / 100
  end


end
