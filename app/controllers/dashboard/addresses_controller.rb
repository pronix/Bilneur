class Dashboard::AddressesController < Dashboard::ApplicationController
  helper Admin::BaseHelper
  helper Admin::NavigationHelper
  helper CheckoutHelper

  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  def index
  end

  def show
  end

  def new
    @address = Address.default
  end
  def create
    if (@address = current_user.addresses.create(params[:address]))
      redirect_to dashboard_addresses_path, :notice => "Addres saved."
    else
      render :new
    end

  end

  def edit
    @address = current_user.addresses.find(params[:id])
    session["user_return_to"] = request.env['HTTP_REFERER']
  end

  def update
    @address = current_user.addresses.find(params[:id])
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
    @address = current_user.addresses.find(params[:id])
    if @address.can_be_deleted?
      @address.destroy
    else
      @address.update_attribute(:deleted_at, Time.now)
    end
    redirect_to(request.env['HTTP_REFERER'] || account_path) unless request.xhr?
  end

end
