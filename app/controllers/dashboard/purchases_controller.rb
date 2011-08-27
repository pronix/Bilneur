class Dashboard::PurchasesController < Dashboard::ApplicationController

  def index
    @orders = current_user.orders.complete.paginate(:per_page => (params[:per_page]||10), :page => params[:page], :order => "created_at")
  end

end
