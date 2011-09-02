class Dashboard::FavoritesController < Dashboard::ApplicationController

  def sellers
    @sellers = @current_user.favorite_sellers
  end

  def destroy
    @current_user.remove_seller_from_favorite(User.find(params[:seller]))
    respond_to do |format|
      format.js  { render :partial => "shared/flash_notice", :locals => { :message => "Seller has been deleted from favorites." } }
    end
  end

end
