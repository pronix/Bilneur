class SellerProductsController < Spree::BaseController
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  helper :taxons
  helper :products

  respond_to :html

  def show
    @seller = User.find(params[:id])
    @quotes = @seller.quotes
  end

end
