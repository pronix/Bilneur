class Dashboard::SalesController < Dashboard::ApplicationController
  respond_to :json, :js, :html

  def index
    @orders = current_user.sales.paginate(:per_page => (params[:per_page]||25), :page => params[:page])
    respond_with(@orders)
  end

  def show
    @order = current_user.sales.find_by_number(params[:id])
  end

  def ship
    @order = current_user.sales.find_by_number(params[:id])
    @shipment = @order.shipments.first
    if @shipment.ship
      flash.notice = t('shipment_updated')
    else
      flash[:error] = t('cannot_perform_operation')
    end

    redirect_to dashboard_virtual_orders_path
  end


end
