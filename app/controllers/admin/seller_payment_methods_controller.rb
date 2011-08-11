class Admin::SellerPaymentMethodsController < Admin::ResourceController

  def index
    @payment_methods = SellerPaymentMethod.all
  end

  def show
    @payment_method = SellerPaymentMethod.find(params[:id])
  end

  def approve
    @payment_method = SellerPaymentMethod.find(params[:id])
    @payment_method.verify!
    redirect_to admin_seller_payment_methods_path
  end

  def reject
    @payment_method = SellerPaymentMethod.find(params[:id])
    @payment_method.reject!
    redirect_to admin_seller_payment_methods_path
  end
end
