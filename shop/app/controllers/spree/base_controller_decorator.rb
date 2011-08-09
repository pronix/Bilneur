Spree::BaseController.class_eval do
  include Spree::CurrentVirtualOrder
  helper_method :current_virtual_order

  before_filter :prepare_params

  rescue_from ActiveRecord::StatementInvalid do |exception|
    rescue_invalid_encoding(exception)
  end

  rescue_from ActionController::RedirectBackError do |exception|
    rescue_redirect_back_error(exception)
  end

  # rescue_from ActionView::Template::Error do |exception|
  #   rescue_template_error(exception)
  # end

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


end
