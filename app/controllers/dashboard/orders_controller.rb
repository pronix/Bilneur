class Dashboard::OrdersController < Dashboard::ApplicationController
  respond_to :json, :html, :xml, :pdf

  include ProductHelper

  def index
    params[:search] ||= {}
    @search = current_user.all_orders.complete.metasearch(params[:search])
    @orders = @search.paginate(paginate_options.merge({ :order => "created_at DESC" }))
  end

  def show
    @order = current_user.all_orders.complete.find_by_number(params[:id])
    respond_to do |format|
      format.html
      format.pdf {
        render "dashboard/shared/invoice/#{params[:template] || "invoice"}.pdf.prawn", :layout => false
      }
    end

  end

  # Receiving order
  # @params
  # :id - order number
  # shipment_id - shipment number
  #
  def receive
    if (@order = current_user.all_orders.complete.find_by_number(params[:id])) &&
        (@shipment = @order.shipments.find_by_number(params[:shipment_id]))

      @review = SellerReview.build(@order, current_user, @shipment.seller, params[:review])

      if request.get?
        render :receive
      else

        if @review.save && @shipment.receiving
          redirect_to dashboard_orders_path, :notice => "Order updated."
        else
          render :receive
        end

      end

    else
      redirect_to dashboard_orders_path, :notice => "Record not found."
    end
  end
end
