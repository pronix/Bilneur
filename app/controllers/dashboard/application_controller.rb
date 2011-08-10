class Dashboard::ApplicationController < Spree::BaseController
  layout "dashboard"
  before_filter :authenticate_user!
  before_filter :verify_seller

  private

  def verify_seller
    redirect_to new_dashboard_payment_method_path, :notice => ((flash.notice||"") << "Should enter Payment Method") and
      return if current_user.has_role?("seller") &&
      current_user.seller_payment_methods.count == 0 &&
      controller_name != "payment_methods"

  end

end
