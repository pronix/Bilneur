class Dashboard::ProductsController < Dashboard::ApplicationController
  helper Admin::BaseHelper
  helper Admin::NavigationHelper
  before_filter :find_product, :only => [:edit, :update]

  def index
    @products = Product.active.paginate(:per_page => 10, :page => params[:page])
  end

  def new
    @product = current_user.products.new
  end

  def create
    @product = current_user.products.new(params[:product])
    if @product.save!
      flash.notice = "Product is created."
      render :edit
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update_attributes(params[:product])
      redirect_to dashboard_products_path, :notice => "Product updated."
    else
      render :edit
    end
  end

  def destroy
    find_product
    if @product.destroy
      flash.notice = "Product deleted."
    else
      flash.notice = "Product is not deleted."
    end
    redirect_to dashboard_products_path
  end
  private
  def find_product
    @product = (current_user.is_admin? ? Product : current_user.products).find_by_permalink(params[:id])
  end
end
