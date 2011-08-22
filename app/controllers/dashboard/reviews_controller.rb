class Dashboard::ReviewsController < Dashboard::ApplicationController
  helper :reviews
  before_filter :load_review, :only => [:approve, :destroy]
  before_filter :filter_params, :only => :index

  # respond_to :html, :js
  def index
    #FIXME doubled ajax request :(
    if request.xhr?
      respond_to do |format|
        format.js  {render :layout => false }
      end
    end
  end

  def approve
    if @review.update_attribute(:approved, true)
       @review.product.recalculate_rating
       flash.notice = t("info_approve_review")
    else
       flash.notice = t("error_approve_review")
    end
    render :nothing => true
  end

  def destroy
    @review.destroy
    flash.notice = 'Review successfully removed'
    render :nothing => true
  end

  private

  def filter_params
    @state = params[:state]
    @reviews = case params[:state]
               when "left" then current_user.reviews
               when "as_seller" then current_user.buyer_reviews
               when "product" then current_user.reviews_as_owner
               else current_user.seller_reviews
    end
    @reviews = params[:approved_select_hz].blank? ? @reviews : @reviews.where(:approved => params[:approved_select_hz])
    @reviews = params[:select_product_id].blank? ? @reviews : @reviews.where(:product_id => params[:select_product_id])

    @reviews = @reviews.paginate(:per_page => (params[:per_page]||15), :page => params[:page])
    # For display some selectboxes
    @select_products = true if params[:state] == "product"
    # @reviews
  end

  def load_review
    @review = Review.find(params[:id])
  end

end
