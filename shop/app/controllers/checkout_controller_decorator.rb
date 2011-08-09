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
  def load_order
    @order = params.has_key?(:order_type) ? current_virtual_order.try(:order) : current_order
    redirect_to cart_path and return unless @order and @order.checkout_allowed?
    redirect_to cart_path and return if @order.completed?
    if @order.virtual?
      @order.state = "delivery" if params[:state] && params[:state] == 'address'
      @order.state = params[:state] if params[:state] && params[:state] != 'address'
    else
      @order.state = params[:state] if params[:state]
    end

    state_callback(:before)

  end
end
