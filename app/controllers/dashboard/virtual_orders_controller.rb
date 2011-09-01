class Dashboard::VirtualOrdersController < Dashboard::ApplicationController

  def index
    @orders = current_user.virtual_orders.complete.paginate( paginate_options.merge({ :order => "created_at" }) )
  end

  def show
    @order = current_user.virtual_orders.complete.find_by_number(params[:id])
  end

end
