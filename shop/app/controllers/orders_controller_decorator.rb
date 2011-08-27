OrdersController.class_eval do

  def empty
    if (@order =
        ((params.has_key?(:cart_type) && params[:cart_type]== 'virtual') ? current_virtual_order :
         current_order))
      @order.line_items.destroy_all
    end

    respond_with(@order) { |format| format.html { redirect_to cart_path } }
  end


  def update
    @order = (params.has_key?(:cart_type) && params[:cart_type]== 'virtual') ? current_virtual_order : current_order
    if @order.update_attributes(params[:order])

      @order.line_items = @order.line_items.select {|li| li.quantity > 0 }
      respond_with(@order) { |format| format.html { redirect_to cart_path } }
    else
      respond_with(@order)
    end
  end


  # Adds a new item to the order (creating a new order if none already exists)
  #
  # Parameters can be passed using the following possible parameter configurations:
  #
  # * Single variant/quantity pairing
  # +:variants => {variant_id => quantity}+
  #
  # * Multiple products at once
  # +:products => {product_id => variant_id, product_id => variant_id}, :quantity => quantity +
  # +:products => {product_id => variant_id, product_id => variant_id}}, :quantity => {variant_id => quantity, variant_id => quantity}+
  def populate
    @order = (params.has_key?(:to_add) && params[:to_add] == 'virtual_store') ? current_virtual_order(true) : current_order(true)

    flash[:error] = []
    params[:products].each do |product_id,variant_id|
      quantity = params[:quantity].to_i if !params[:quantity].is_a?(Hash)
      quantity = params[:quantity][variant_id].to_i if params[:quantity].is_a?(Hash)
      variant = Variant.find(variant_id)
      if (params[:quantity].to_s !~ /\A[+-]?\d+\Z/) || (quantity > variant.count_on_hand) || (quantity < 0)
        flash[:error] << [ "\"#{variant.name}\": in stock only #{variant.count_on_hand} " ]
      end
      @order.add_variant(variant, quantity) if quantity > 0
    end if params[:products]



    params[:variants].each do |variant_id, quantity|
      variant = Variant.find(variant_id)
      count_in_order = @order.line_items.find_by_variant_id(variant.id).try(:quantity).to_i
      if (quantity.to_s !~ /\A[+-]?\d+\Z/) ||
          (quantity.to_i > (variant.count_on_hand - count_in_order)) ||
          (quantity.to_i < 0)
        flash[:error] << [ "\"#{variant.name}\": in stock only #{variant.count_on_hand} " ]
      end
      quantity = quantity.to_i
      @order.add_variant(variant, quantity) if quantity > 0 && variant
    end if params[:variants]
    puts "="*90
    puts flash.inspect

    if flash[:error].present?
      flash[:error] = [flash[:error]].flatten.join
    else
      flash.delete(:error)
    end

    respond_with(@order) { |format|
      format.html { redirect_to cart_path }
      format.js { render :layout => false }
    }
  end


end
