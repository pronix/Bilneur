Calculator::Vat.class_eval do

  # computes vat for line_items associated with order, and tax rate
  def compute(order, *args)
    rate = self.calculable
    line_items = order.line_items.select { |i| i.product.tax_category == rate.tax_category }
    line_items.inject(0) {|sum, line_item|
      sum += (line_item.price * rate.amount * line_item.quantity)
    }
  end

end
