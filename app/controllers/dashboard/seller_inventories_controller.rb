class Dashboard::SellerInventoriesController < Dashboard::ApplicationController
  def index
    @seller_stores = current_user.seller_stores
  end
end
