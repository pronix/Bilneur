Spree::BaseController.class_eval do
  include Spree::CurrentVirtualOrder
  helper_method :current_virtual_order
  helper_method :favorite_products

  before_filter :prepare_params

  rescue_from ActiveRecord::StatementInvalid do |exception|
    rescue_invalid_encoding(exception)
  end

  rescue_from ActionController::RedirectBackError do |exception|
    rescue_redirect_back_error(exception)
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render_404(exception)
  end

  # rescue_from ActionView::Template::Error do |exception|
  #   rescue_template_error(exception)
  # end

 def unauthorized
    respond_to do |format|
      format.html do
        if current_user
          flash[:error] = I18n.t(:only_for_sellers)
          redirect_back_or_default(dashboard_root_path)
        else
          flash[:error] = I18n.t(:authorization_failure)
          store_location
          redirect_to login_path and return
        end
      end
      format.xml do
        request_http_basic_authentication 'Web Password'
      end
      format.json do
        render :text => "Not Authorized \n", :status => 401
      end
    end
  end

  private

  def prepare_params
    if (params||{ }).has_key?(:page) && params[:page].class.to_s != "ActiveSupport::HashWithIndifferentAccess"
      params[:page] = (params[:page].to_i == 0 ? 1 : params[:page].to_i.abs)
    end
  end

  def rescue_template_error(exception)
    redirect_to root_path, :notice => "Bad request" and return
  end

  def rescue_redirect_back_error(exception)
    redirect_to root_path, :notice => "Bad request" and return
  end

  def rescue_invalid_encoding(exception)
    head :bad_request
  end

  def favorite_products
    current_user ? current_user.favorite_variants : Variant.active.where(:id => (session[:favorite_products]||[]))
  end

end
