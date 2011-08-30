class Dashboard::FavoritesController < Dashboard::ApplicationController

  def sellers
    @sellers = @current_user.favorite_sellers
  end

end
