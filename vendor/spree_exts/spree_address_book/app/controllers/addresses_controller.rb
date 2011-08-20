class AddressesController < Spree::BaseController
  helper CheckoutHelper
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  load_and_authorize_resource

  def make
    @order = Order.find_by_number(params[:order_id])

    if params[:id]
      @address = current_user.addresses.find(params[:id])
      @address.update_attributes(params[:address])
    else
      @address = current_user.addresses.create(params[:address])
    end

    render "make_#{params[:state]}", :layout => false
  end

  def info
    if (@address = current_user.addresses.find(params[:id]))
      render :partial => "checkout/address_info",:object => @address,  :layout => false
    else
      render :nothing => true
    end

  end


  def edit
    session["user_return_to"] = request.env['HTTP_REFERER']
  end

  def update
    if @address.editable?
      if @address.update_attributes(params[:address])
        flash[:notice] = I18n.t(:successfully_updated, :resource => I18n.t(:address))
      end
    else
      new_address = @address.clone
      new_address.attributes = params[:address]
      @address.update_attribute(:deleted_at, Time.now)
      if new_address.save
        flash[:notice] = I18n.t(:successfully_updated, :resource => I18n.t(:address))
      end
    end
    redirect_back_or_default(account_path)
  end

  def destroy
    if @address.can_be_deleted?
      @address.destroy
    else
      @address.update_attribute(:deleted_at, Time.now)
    end
    redirect_to(request.env['HTTP_REFERER'] || account_path) unless request.xhr?
  end
end
