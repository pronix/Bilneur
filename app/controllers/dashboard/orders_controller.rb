class Dashboard::OrdersController < Dashboard::ApplicationController

  def index
    @orders = current_user.orders.complete
  end

  def show
    @order = current_user.orders.complete.find_by_number(params[:id])
  end

end
