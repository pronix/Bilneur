class Dashboard::SalesController < Dashboard::ApplicationController
  respond_to :json, :js, :html

  def index
    @orders = current_user.sales.complete.paginate(:per_page => (params[:per_page]||25), :page => params[:page], :order => "orders.created_at DESC")
    respond_with(@orders)
  end

  def show
    @order = current_user.sales.find_by_number(params[:id])
  end

  def ship
    @order = current_user.sales.find_by_number(params[:id])
    @shipment = @order.shipments.find_by_seller_id(current_user.id)
    if @shipment.ship
      flash.notice = t('shipment_updated')
    else
      flash[:error] = t('cannot_perform_operation')
    end

    redirect_to dashboard_sales_path
  end


end
