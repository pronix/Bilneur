Calculator::FlatPercentItemTotal.class_eval do

  def compute(object, *args)
    return unless object.present? and object.line_items.present?
    item_total = object.line_items.map(&:amount).sum
    value = item_total * self.preferred_flat_percent / 100.0
    (value * 100).round.to_f / 100
  end


end
