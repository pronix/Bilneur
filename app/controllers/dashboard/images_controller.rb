class Dashboard::ImagesController < Dashboard::ApplicationController

  helper Admin::BaseHelper
  helper Admin::NavigationHelper

  before_filter :load_data

  def index
  end

  def new
    @image = Image.new
    respond_to do |format|
      format.js  { render :layout => false }
    end

  end

  def create
    if (@image = Image.create(params[:image].merge({ :viewable => @product})))
      redirect_to dashboard_product_images_path(@product), :notice => "Image saved."
    else
      render :new
    end
  end

  def edit
    @image = @product.images.find(params[:id])
  end

  def update
    @image = @product.images.find(params[:id])

    if @image && (@image.update_attributes(params[:image].merge({ :viewable => @product})))
      redirect_to dashboard_product_images_path(@product), :notice => "Image updated."
    else
      render :edit
    end

  end

  def destroy

    @image = @product.images.find(params[:id])
    @viewable = @image.try(:viewable)

    if @image.destroy
      flash.notice = "Image destroyed."
    else
      flash.notice = "Occured when destroying image."
    end
    render :text => flash.notice
    # redirect_to dashboard_product_images_path(@product)
  end

  def update_positions
    params[:positions].each do |id, index|
      Image.update_all(['position=?', index], ['id=?', id])
    end

    respond_to do |format|
      format.js  { render :text => 'Ok' }
    end
  end

  private

  def location_after_save
    admin_product_images_url(@product)
  end

  def load_data
    @product = Product.find_by_permalink(params[:product_id])
  end

end
