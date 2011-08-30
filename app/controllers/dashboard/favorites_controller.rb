class Dashboard::FavoritesController < Dashboard::ApplicationController

  def sellers
    @sellers = @current_user.favorite_sellers
  end

  def destroy
    @current_user.favorite_sellers.find(params[:seller]).delete
    render :nothing => true
  end

end
