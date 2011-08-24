class SellersController < Spree::BaseController
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  helper :taxons
  helper :products
  respond_to :html, :js, :json

  before_filter :load_data

  def store
    @quotes = @seller.quotes.paginate(:page => params[:page], :per_page => params[:per_page])
  end

  def product
    @product = @seller.products.find_by_permalink(params[:product_id])
    @reviews = @product.reviews.paginate_reviews(params[:per_page])
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
