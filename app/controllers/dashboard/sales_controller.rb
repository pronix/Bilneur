class Dashboard::SalesController < Dashboard::ApplicationController
  respond_to :json, :js, :html

  helper Admin::BaseHelper
  helper Admin::NavigationHelper


  def index
    @orders = current_user.sales.paginate(:per_page => (params[:per_page]||25), :page => params[:page])
    respond_with(@orders)
  end

  def show
    @order = current_user.sales.find_by_number(params[:id])
  end

end
