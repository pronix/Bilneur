class GroupSaleCheckoutController < Spree::BaseController

  after_filter :normalize_addresses, :only => :update
  before_filter :set_addresses, :only => :update

  before_filter :check_registration, :except => [:registration, :update_registration]

  before_filter :load_order, :except => [ :registration, :update_registration, :populate ]



  respond_to :html, :js


  def registration
    @user = User.new
  end

  def update_registration
    redirect_to group_sale_checkout_path
  end




  def populate
    @order = current_user.group_orders.incomplete.last || Order.build_group_order(current_user)
    @order.state = 'cart'
    @order.ship_address = nil
    @order.bill_address = nil

    @order.save!

    @group_sale = GroupSale.find(params[:id])
    redirect_to :back, :notice => "Not found group sale" and return unless @order.present?
    @quantity = ( params[:quantity]||1 ).to_i

    if @order.add_group_sale(@group_sale, @quantity)
      redirect_to group_sale_checkout_path and return
    else
      redirect_to :back, :notice => "Errors" and return
    end



  end





  # Updates the order and advances to the next state (when possible.)
  def update
    puts "'"*90
    puts object_params.inspect
    puts "'"*90
    @order.update_attributes(object_params)
    puts @order.errors
    if @order.update_attributes(object_params)
      puts '~'*90
      if @order.next!
        state_callback(:after)
      else
        flash[:error] = I18n.t(:payment_processing_failed)
        respond_with(@order, :location => group_sale_checkout_state_path(@order.state))
        return
      end

      if @order.state == "complete" || @order.completed?
        flash[:notice] = I18n.t(:order_processed_successfully)
        flash[:commerce_tracking] = "nothing special"
        respond_with(@order, :location => completion_route)
      else
        respond_with(@order, :location => group_sale_checkout_state_path(@order.state))
      end
    else
      puts '+'*90
      respond_with(@order) { |format| format.html { render :edit } }
    end
  end

  private

  # Provides a route to redirect after order completion
  def completion_route
    order_path(@order)
  end

  def object_params
    # For payment step, filter order parameters to produce the expected nested attributes for a single payment and its source, discarding attributes for payment methods other than the one selected
    if @order.payment?
      if params[:payment_source].present? && source_params = params.delete(:payment_source)[params[:order][:payments_attributes].first[:payment_method_id].underscore]
        params[:order][:payments_attributes].first[:source_attributes] = source_params
      end
      if (params[:order][:payments_attributes])
        params[:order][:payments_attributes].first[:amount] = @order.total
      end
    end
    params[:order]
  end

  def load_order
    @order = current_user.group_orders.incomplete.last || Order.build_group_order(current_user)
    @order.state = params[:state] if params[:state]
    state_callback(:before)
    puts "="*90
    puts @order.inspect
    puts "="*90
  end

  def state_callback(before_or_after = :before)
    method_name = :"#{before_or_after}_#{@order.state}"
    puts "-"*90
    puts method_name
    puts "-"*90
    send(method_name) if respond_to?(method_name, true)
  end

  def before_address
    @order.bill_address ||= Address.default
    @order.ship_address ||= Address.default
  end

  def before_delivery
    return if params[:order].present?
    @order.shipping_method ||= (@order.rate_hash.first && @order.rate_hash.first[:shipping_method])
  end

  def before_payment
    current_order.payments.destroy_all if request.put?
  end

  def after_complete

  end

  def rescue_from_spree_gateway_error
    flash[:error] = t('spree_gateway_error_flash_for_checkout')
    render :edit
  end

  # Introduces a registration step whenever the +registration_step+ preference is true.
  def check_registration
    return if current_user
    store_location
    redirect_to group_sale_checkout_registration_path
  end


  protected

  def set_addresses
    return unless params[:order] && (params[:state] == "address" || params[:state] == "payment")

    if params[:order][:ship_address_id].to_i > 0
      params[:order].delete(:ship_address_attributes)
    else
      params[:order].delete(:ship_address_id)
    end

    if params[:order][:bill_address_id].to_i > 0
      params[:order].delete(:bill_address_attributes)
    else
      params[:order].delete(:bill_address_id)
    end
  end

  def normalize_addresses
    return unless params[:state] == "address" && @order.bill_address_id && @order.ship_address_id
    @order.bill_address.reload
    @order.ship_address.reload
    if @order.bill_address_id != @order.ship_address_id && @order.bill_address.same_as?(@order.ship_address)
      @order.bill_address.destroy
      @order.update_attribute(:bill_address_id, @order.ship_address.id)
    else
      @order.bill_address.update_attribute(:user_id, current_user.try(:id))
    end
    @order.ship_address.update_attribute(:user_id, current_user.try(:id))
  end


end
