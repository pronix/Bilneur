class Dashboard::SalesController < Dashboard::ApplicationController
  respond_to :json, :js, :html

  def index
    @orders = current_user.sales.complete.paginate( paginate_options.merge({ :order => "created_at DESC" }) )
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

  def track
    @order = current_user.sales.find_by_number(params[:id])
    @shipment = @order.shipment_for_seller(current_user)
    unless request.get?
      if @shipment && (@shipment.update_attribute(:tracking, params[:tracking]))
        flash.notice = "Tracking updated."
      else
        flash.notice = "Tracking not updated."
      end

      redirect_to dashboard_sales_path
    end

  end
end
