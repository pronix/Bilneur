class Dashboard::FavoritesController < Dashboard::ApplicationController

  def sellers
    @sellers = @current_user.favorite_sellers
  end

  def destroy
    @current_user.remove_seller_from_favorite(User.find(params[:seller]))
    render :nothing => true
  end

end
