CheckoutController.class_eval do

  private

  # def before_address
  #   @order.bill_address ||= current_user.try(:default_address)
  #   @order.ship_address ||= current_user.try(:default_address)
  # end

  def before_delivery
    return if params[:order].present?

    unless @order.children.blank?
      @children_orders = [ ]
      @order.children.each do |child|
        @order.shipping_method ||= (child.rate_hash.first && child.rate_hash.first[:shipping_method])
        child.shipping_method ||= (child.rate_hash.first && child.rate_hash.first[:shipping_method])
        @children_orders << child
      end
    else
      @order.shipping_method ||= (@order.rate_hash.first && @order.rate_hash.first[:shipping_method])
    end

  end

end
