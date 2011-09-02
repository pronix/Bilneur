CheckoutController.class_eval do
  before_filter :prepare_paypal, :only => [:update]

  respond_to :html, :js


  def address_info
    if (@address = current_user.addresses.find(params[:id]))
      render :partial => "address_info",:object => @address,  :layout => false
    else
      render :nothing => true
    end

  end

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
  # Introduces a registration step whenever the +registration_step+ preference is true.

  def check_registration
    return unless Spree::Auth::Config[:registration_step]
    return if current_user or current_order.email
    store_location
    if @order.virtual?
      redirect_to virtual_checkout_registration_path(:virtual)
    else
      redirect_to checkout_registration_path()
    end
  end


  def after_complete
    if @order.virtual?
      session[:virtual_order_id] = nil
    else
      session[:order_id] = nil
    end
  end


  def before_address
    @order.bill_address ||= (current_user && current_user.addresses.first.try(:clone)) || Address.default
    @order.ship_address ||= (current_user && current_user.addresses.first.try(:clone)) || Address.default
  end

  def before_delivery
    return if params[:order].present?
  end

  def load_order
    @order = (params.has_key?(:order_type) && params[:order_type] == 'virtual') ? current_virtual_order.try(:order) : current_order

    redirect_to cart_path and return unless @order and @order.checkout_allowed?
    redirect_to cart_path and return if @order.completed?

    # Checked products quatity
    #
    unless (@count_on_hand_errors = @order.check_product_quantity).blank?
      flash[:error] = @count_on_hand_errors.join('')
      redirect_to cart_path and return
    end


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
  private
  def prepare_paypal
    if params[:paypal] && (params[:state] == "payment")
      if params[:order][:bill_address_attributes]
        order_params = {:order => {:bill_address_attributes => params[:order][:bill_address_attributes]}}
        if @order.update_attributes(order_params) &&
            (@payment_method = (@order.virtual? ? PaymentMethod.vpaypal(:front_end) : PaymentMethod.paypal(:front_end)))
          load_order
          redirect_to paypal_payment_order_checkout_url(@order, :payment_method_id => @payment_method.id) and return
         end
      end
    end
  end
end
