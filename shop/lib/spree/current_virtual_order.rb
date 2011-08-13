module Spree
  module CurrentVirtualOrder

    # The current incomplete order from the session for use in cart and during checkout
    def current_virtual_order(create_order_if_necessary = false)

      return @current_virtual_order if @current_virtual_order

      if session[:virtual_order_id]
        @current_virtual_order = VirtualOrder.find_by_id(session[:virtual_order_id], :include => :adjustments)
      end

      if create_order_if_necessary and (@current_virtual_order.nil? or @current_virtual_order.completed?)
        @current_virtual_order = VirtualOrder.new
        @current_virtual_order.save!
        session[:access_virtual_token] = @current_virtual_order.token
      end

      session[:virtual_order_id] = @current_virtual_order ? @current_virtual_order.id : nil
      @current_virtual_order
    end

  end

end
