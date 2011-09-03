class Dashboard::GroupSalesController < Dashboard::ApplicationController

  before_filter :load_variant, :only => [:new, :create]

  def index
    @group_sales = current_user.group_sales.paginate(paginate_options.merge({ :order => "group_sales.created_at DESC"}))
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
  end

  def destroy
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
end
