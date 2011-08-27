class Dashboard::SellerInventoriesController < Dashboard::ApplicationController
  def index
    @seller_stores = current_user.seller_stores.paginate(:page => params[:page], :per_page => params[:per_page])
  end
end
