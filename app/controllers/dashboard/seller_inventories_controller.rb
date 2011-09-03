class Dashboard::SellerInventoriesController < Dashboard::ApplicationController
  before_filter lambda{ authorize! :access, :seller }
  def index
    @seller_stores = current_user.seller_stores.paginate(:page => params[:page], :per_page => params[:per_page])
  end
end
