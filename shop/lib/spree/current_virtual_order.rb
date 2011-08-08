module Spree
  module CurrentVirtualOrder
    # Associate the new order with the currently authenticated user before saving
    def before_save_new_order
      @current_virtual_order && @current_virtual_order.user ||= current_user
    end


    # This should be overridden by an auth-related extension which would then have the
    # opporutnity to store tokens, etc. in the session # after saving.
    def after_save_new_order
    end

    # The current incomplete order from the session for use in cart and during checkout
    def current_virtual_order(create_order_if_necessary = false)
      return @current_virtual_order if @current_virtual_order

      if session[:virtual_order_id]
        @current_virtual_order = VirtualOrder.find_by_id(session[:virtual_order_id], :include => :adjustments)
      end

      if create_order_if_necessary and (@current_virtual_order.nil? or @current_virtual_order.completed?)
        @current_virtual_order = VirtualOrder.new
        before_save_new_order
        @current_virtual_order.save!
        after_save_new_order
      end

      session[:virtual_order_id] = @current_virtual_order ? @current_virtual_order.id : nil
      @current_virtual_order
    end

  end

end
