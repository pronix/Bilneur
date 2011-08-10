class Dashboard::PaymentMethodsController < Dashboard::ApplicationController

  helper Admin::BaseHelper
  helper Admin::NavigationHelper


  def index
    @payment_methods = current_user.seller_payment_methods
  end

  def show
    @payment_method = current_user.seller_payment_methods.find(params[:id])
  end

  def new
    @payment_method = current_user.seller_payment_methods.new
  end

  def create
    @payment_method = SellerPaymentMethod.build(params[:payment_method].merge({ :user => current_user}))
    if @payment_method.valid?
      render :edit
    else
      render :new
    end
  end

  def edit
    @payment_method = current_user.seller_payment_methods.find(params[:id])
  end

  def update
    @payment_method = SellerPaymentMethod.detect(current_user, params[:id])
    if @payment_method.update_attributes(params[:payment_method])
      redirect_to dashboard_payment_methods_path, :notice => I18n.t(:successfully_updated, :resource => I18n.t(:payment_method))
    else
      render :edit
    end
  end

  def verify
    @payment_method = current_user.seller_payment_methods.find(params[:id])
    @payment_method.to_verify
    redirect_to dashboard_payment_methods_path, :notice => "Payment method sent to verification."
  end

  def destroy
    @payment_method = current_user.seller_payment_methods.find(params[:id])
    if @payment_method.destroy
      flash.notice = "Payment method has been successfully destroyed!"
    end
    redirect_to dashboard_payment_methods_path
  end


end
