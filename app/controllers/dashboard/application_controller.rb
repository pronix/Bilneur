class Dashboard::ApplicationController < Spree::BaseController
  helper Admin::BaseHelper
  helper Admin::NavigationHelper


  layout "dashboard"
  before_filter :authenticate_user!
  before_filter :verify_seller

  private

  def render_js_for_destroy
    render :partial => "/admin/shared/destroy"
  end

  def verify_seller
    redirect_to new_dashboard_payment_method_path, :notice => ((flash.notice||"") << "Should enter Payment Method") and
      return if current_user.has_role?("seller") &&
      current_user.seller_payment_methods.count == 0 &&
      controller_name != "payment_methods"

  end
  def paginate_options
    {
      :per_page => (params[:per_page]||Spree::Config[:dashboard_per_page]||5),
      :page => params[:page]
    }
  end
end
