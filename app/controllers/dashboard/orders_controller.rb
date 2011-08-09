class Dashboard::OrdersController < Dashboard::ApplicationController
  helper Admin::BaseHelper
  helper Admin::NavigationHelper

  def index
    @orders = current_user.orders
  end

  def show
    @order = current_user.orders.find_by_number(params[:id])
  end

end
