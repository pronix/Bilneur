class Dashboard::ProductsController < Dashboard::ApplicationController
  helper Admin::BaseHelper
  helper Admin::NavigationHelper
  def index
    @products = current_user.products.paginate(:per_page => 10, :page => params[:page])
  end

  def new
    @product = current_user.products.new
  end

  def create
    if @product = current_user.products.create(params[:product])
      render :edit
    else
      render :new
    end
  end

  def edit
    @product = current_user.products.find_by_permalink(params[:id])
  end

  def update
    @product = current_user.products.find_by_permalink(params[:id])
    if @product.update_attributes(params[:product])
      redirect_to dashboard_products_path
    else
      render :edit
    end
  end

end
