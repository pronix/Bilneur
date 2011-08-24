class SellersController < Spree::BaseController
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  helper :taxons
  helper :products
  respond_to :html, :js, :json

  before_filter :load_data

  def store
    @quotes = @seller.quotes.paginate(:page => params[:page], :per_page => params[:per_page])
  end

  def quote
    @quote = @seller.quotes.by_product_and_id(Product.find_by_permalink(params[:product_id]), params[:quote_id])
    # FIXME 
    @reviews = @quote.product.reviews.paginate_reviews(params[:per_page])
    @product_properties = @quote.product.product_properties
  end

  def about
  end

  def customer_service
  end

  def feedback
  end

  def return_policy
  end

  private

  def load_data
    @seller = Role.seller.users.find(params[:id])
  end

end
