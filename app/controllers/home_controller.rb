class HomeController < Spree::BaseController
  #layout "spree_application"
  helper Spree::BaseHelper

  def index
    @latest_products = Product.latest
  end

  # @kind:
  #   products
  #   sellers
  #   deals
  def top
    case params[:kind].to_s
    when "products"
      'a'
    when "sellers"
      redirect_to root_path and return
    when "deals"
      redirect_to root_path and return
    else
      redirect_to root_path and return
    end
  end

end
