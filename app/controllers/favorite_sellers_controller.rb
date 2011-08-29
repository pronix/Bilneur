class FavoriteSellersController < Spree::BaseController
  before_filter lambda{ @seller = User.find(params[:id]) }

  def add
    if current_user
      current_user.add_seller_to_favorite(@seller)
    else
      (session[:favorite_sellers] ||= [ ]) << @seller.id
    end
    render :nothing => true
  end

end
