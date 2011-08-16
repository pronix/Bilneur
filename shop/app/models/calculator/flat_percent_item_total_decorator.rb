Calculator::FlatPercentItemTotal.class_eval do

  def compute(object, *args)
    return unless object.present? and object.line_items.present?
    @seller = self.calculable && self.calculable.seller

    item_total = ( @seller ? object.line_items.select{ |v| v.variant.seller == @seller } : object.line_items ).map(&:amount).sum
    value = item_total * self.preferred_flat_percent / 100.0
    (value * 100).round.to_f / 100
  end


end
