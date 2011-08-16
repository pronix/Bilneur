Calculator::Vat.class_eval do

  # computes vat for line_items associated with order, and tax rate
  def compute(order, *args)
    @seller = self.calculable && self.calculable.seller
    rate = self.calculable
    line_items =
      if @seller
        order.line_items.select { |i| (i.variant.seller == @seller) && (i.product.tax_category == rate.tax_category) }
      else
        order.line_items.select { |i| i.product.tax_category == rate.tax_category }
      end
    line_items.inject(0) {|sum, line_item|
      sum += (line_item.price * rate.amount * line_item.quantity)
    }
  end

end
