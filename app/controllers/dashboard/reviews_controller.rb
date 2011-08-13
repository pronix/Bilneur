class Dashboard::ReviewsController < Dashboard::ApplicationController
  helper :reviews
  before_filter :load_review, :only => [:approve, :destroy]

  def index
    @approved_reviews = Review.by_products_owner(@current_user).where(:approved => true)
    @unapproved_reviews = Review.by_products_owner(@current_user).where(:approved => false)
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
