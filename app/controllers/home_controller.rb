class HomeController < Spree::BaseController
  #layout "spree_application"
  helper Spree::BaseHelper

  def index
    @products = Product.tops.first(10)
    @sellers = User.sellers_top.limit(10)
    @deals = Product.top_deals.first(10)
  end

  # @kind:
  #   products
  #   sellers
  #   deals
  def top
    case params[:kind].to_s
    when "products"
      # Return only 10 items
      @products = Product.tops.first(10)
    when "sellers"
      # Return only 10 best sellers
      @sellers = User.sellers_top.limit(10)
    when "deals"
      @deals = Product.top_deals.first(10)
    else
      redirect_to root_path and return
    end
  end

end
