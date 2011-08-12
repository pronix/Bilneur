class Dashboard::ReviewsController < Dashboard::ApplicationController
  helper :reviews

  def index
    @approved_reviews = Review.by_products_owner(@current_user).where(:approved => true)
    @unapproved_reviews = Review.by_products_owner(@current_user).where(:approved => false)
  end

  def approve
    r = Review.find(params[:id])

    if r.update_attribute(:approved, true)
       r.product.recalculate_rating
       flash[:notice] = t("info_approve_review")
    else
       flash[:error] = t("error_approve_review")
    end
    redirect_to admin_reviews_path
  end

end
