class SellersController < Spree::BaseController
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  helper :taxons
  helper :products
  respond_to :html, :js, :json

  before_filter :filter_params, :only => :feedback
  before_filter :load_data

  def store
    @quotes = @seller.quotes.paginate(:page => params[:page], :per_page => params[:per_page])
  end

  def quote
    @quote = @seller.quotes.by_product_and_id(Product.find_by_permalink(params[:product_id]), params[:quote_id])
    # FIXME 
    @reviews = @quote.product.reviews.paginate_reviews(params[:per_page])
    @seller = @quote.seller
    @product_properties = @quote.product.product_properties
  end

  def about
  end

  def customer_service
  end

  def feedback
    if request.xhr?
      respond_to do |format|
        format.js  {render :layout => false }
      end
    end
  end

  def return_policy
  end

  private

  def load_data
    @seller = Role.seller.users.find(params[:id])
  end

  def filter_params
    load_data
    @state = params[:state] ? params[:state] : 'as_buyer'
    @reviews = case @state
               # Return all my review when I am seller or buyer
               when "left" then @seller.my_reviews
               # Return all reviews from buyers
               when "as_seller" then @seller.buyer_reviews
               # Return all reviews from my product
               when "product" then @seller.reviews_as_owner
               # Return all reviews from sellers
               when "as_buyer" then @seller.seller_reviews
    end
    @reviews = params[:approved_select_hz].blank? ? @reviews : @reviews.where(:approved => params[:approved_select_hz])
    @reviews = params[:select_product_id].blank? ? @reviews : @reviews.where(:product_id => params[:select_product_id])

    @reviews = @reviews.paginate(:per_page => (params[:per_page]||15), :page => params[:page])
  end
end
