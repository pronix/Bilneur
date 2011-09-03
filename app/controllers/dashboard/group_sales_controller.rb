class Dashboard::GroupSalesController < Dashboard::ApplicationController

  before_filter :load_variant, :only => [:new, :create]
  before_filter :load_group_sale, :only => [:show, :edit, :update, :destroy, :cancel, :complete]

  def index
    authorize! :read, GroupSale
    @group_sales = current_user.group_sales.paginate(paginate_options.merge({ :order => "group_sales.created_at DESC"}))
  end

  def show

  end

  # @params
  # quote_id
  #
  def new
    @group_sale = current_user.group_sales.new(:variant => @variant)
  end

  def create
    if (@group_sale = current_user.group_sales.create(params[:group_sale].merge({ :variant => @variant }))).valid?
      redirect_to dashboard_group_sales_path, :notice => "Group sale created."
    else
      render :new
    end
  end


  def edit
  end

  def update
    if @group_sale.update_attributes(params[:group_sale]) && @group_sale.valid?
      redirect_to dashboard_group_sales_path, :notice => "Group sale updated."
    else
      render :edit
    end
  end

  def destroy
    if @group_sale.destroy
      flash.notice = "Group sale deleted."
    else
      flash[:error] = "Group sale not deleted."
    end

    redirect_to dashboard_group_sales_path
  end

  def cancel

  end

  def complete

  end

  private

  def load_variant
    @variant = current_user.quotes.find(params[:quote_id])

    @product = @variant.product if @variant
  end

  def load_group_sale
    @group_sale = current_user.group_sales.find params[:id]
    @variant = @group_sale.variant
    authorize! params[:action].to_sym, @group_sale
  end

end
