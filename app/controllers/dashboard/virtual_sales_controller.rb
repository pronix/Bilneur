class Dashboard::VirtualSalesController < Dashboard::ApplicationController
  respond_to :json, :js, :html

  def index
    @orders = current_user.virtual_sales.paginate(:per_page => (params[:per_page]||25), :page => params[:page])
    respond_with(@orders)
  end

  def show
    @order = current_user.virtual_sales.find_by_number(params[:id])
  end

  def ship
    @order = current_user.virtual_sales.find_by_number(params[:id])
    @shipment = @order.shipments.first
    if @shipment.ship
      flash.notice = t('shipment_updated')
    else
      flash[:error] = t('cannot_perform_operation')
    end

    redirect_to dashboard_virtual_sales_path
  end


end
