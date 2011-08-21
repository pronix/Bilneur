class Dashboard::ReviewsController < Dashboard::ApplicationController
  helper :reviews
  before_filter :load_review, :only => [:approve, :destroy]

  respond_to :html, :js
  def index
    #FIXME doubled ajax request :(
    # @approved_reviews = Review.by_products_owner(@current_user).where(:approved => true)
    # @unapproved_reviews = Review.by_products_owner(@current_user).where(:approved => false)

    @state = params[:state]
    @reviews = case params[:state]
               when "left" then current_user.reviews
               when "as_seller" then current_user.buyer_reviews
               when "product" then current_user.reviews_as_owner
               else current_user.seller_reviews
    end.paginate(:per_page => (params[:per_page]||15), :page => params[:page])
    @select_products = true if params[:state] == "product"
  end

  def approve
    if @review.update_attribute(:approved, true)
       @review.product.recalculate_rating
       flash.notice = t("info_approve_review")
    else
       flash.notice = t("error_approve_review")
    end
    redirect_to dashboard_reviews_path
  end

  def destroy
    @review.destroy
    flash.notice = 'Review successfully removed'
    redirect_to dashboard_reviews_path
  end

  private

  def load_review
    @review = Review.find(params[:id])
  end

end
