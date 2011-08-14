CheckoutController.class_eval do


  # Updates the order and advances to the next state (when possible.)
  def update
    if @order.update_attributes(object_params)
      if @order.next
        state_callback(:after)
      else
        flash[:error] = I18n.t(:payment_processing_failed)
        respond_with(@order, :location => virtual_checkout_state_path(type_order, @order.state))
        return
      end

      if @order.state == "complete" || @order.completed?
        flash[:notice] = I18n.t(:order_processed_successfully)
        flash[:commerce_tracking] = "nothing special"
        respond_with(@order, :location => completion_route)
      else
        respond_with(@order, :location =>  virtual_checkout_state_path(type_order, @order.state))
      end
    else
      respond_with(@order) { |format| format.html { render :edit } }
    end
  end


  private

  def after_complete
    if @order.virtual?
      session[:virtual_order_id] = nil
    else
      session[:order_id] = nil
    end
  end


  def before_address
    @order.bill_address ||= current_user.addresses.first.try(:clone) || Address.default
    @order.ship_address ||= current_user.addresses.first.try(:clone) || Address.default
  end

  def before_delivery
    return if params[:order].present?

    # unless @order.children.blank?
    #   @children_orders = [ ]
    #   @order.children.each do |child|
    #     @order.shipping_method ||= (child.rate_hash.first && child.rate_hash.first[:shipping_method])
    #     child.shipping_method ||= (child.rate_hash.first && child.rate_hash.first[:shipping_method])
    #     @children_orders << child
    #   end
    # else
    #   @order.shipping_method ||= (@order.rate_hash.first && @order.rate_hash.first[:shipping_method])
    # end

  end
  def load_order
    @order = (params.has_key?(:order_type) && params[:order_type] == 'virtual') ? current_virtual_order.try(:order) : current_order
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
  def type_order
    @order.virtual? ? :virtual : :normal
  end
end
