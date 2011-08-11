class Dashboard::ShippingMethodsController < Dashboard::ApplicationController

  before_filter :load_data, :except => [:index]

  def index
    @shipping_methods = current_user.shipping_methods
  end

  def new
    @shipping_method = current_user.shipping_methods.new
  end

  def create
    @shipping_method = current_user.shipping_methods.new(params[:shipping_method])
    if @shipping_method.save
      redirect_to edit_dashboard_shipping_method_path(@shipping_method), :notice => "Shipping method created."
    else
      render :new
    end
  end

  def edit
    @shipping_method = current_user.shipping_methods.find(params[:id])
  end

  def update
    @shipping_method = current_user.shipping_methods.find(params[:id])
    if @shipping_method.update_attributes(params[:shipping_method])
      redirect_to edit_dashboard_shipping_method_path(@shipping_method), :notice => "Shipping method updated."
    else
      render :edit
    end
  end

  def destroy
    @shipping_method = current_user.shipping_methods.find(params[:id])
    if @shipping_method.destroy
      flash.notice = "Shipping method destroyed."
    else
      flash[:error] = "Shipping method not destroyed."
    end
    redirect_to dashboard_shipping_methods_path
  end

  private

  def load_data
    @available_zones = Zone.order(:name)
    @calculators = ShippingMethod.calculators.sort_by(&:name)
  end
end
