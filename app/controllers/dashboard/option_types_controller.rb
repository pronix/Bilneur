class Dashboard::OptionTypesController < Dashboard::ApplicationController

  helper Admin::BaseHelper
  helper Admin::NavigationHelper

  before_filter :load_product, :only => [:selected, :available, :remove]

  def index
    @option_types = OptionType.all
  end

  def new
    @option_type = OptionType.new
    respond_to do |format|
      format.js  { render :layout => false }
    end
  end

  def create
    @option_type = OptionType.new(params[:option_type])
    if @option_type.save
      redirect_to edit_dashboard_option_type_path(@option_type), :notice => "Option Type created."
    else
      render :new
    end
  end

  def edit
    @option_type = OptionType.find(params[:id])
  end

  def update
    @option_type = OptionType.find(params[:id])
    if (@option_type.update_attributes(params[:option_type]))
      redirect_to dashboard_option_types_path, :notice => "Option Type updated."
    else
      render :edit
    end
  end

  def destroy
    @option_type = OptionType.find(params[:id])
    if @option_type.destroy
      flash.notice = "Option Type deleted."
    else
      flash.notice = "Option Type is not deleted."
    end
    redirect_to dashboard_option_types_path
  end

  def available
    set_available_option_types
    render :layout => false
  end

  def selected
    @option_types = @product.option_types
  end

  def remove
    @product.option_types.delete(@option_type)
    @product.save
    flash.notice = I18n.t("notice_messages.option_type_removed")
    redirect_to selected_admin_product_option_types_url(@product)
  end

  def update_positions
    params[:positions].each do |id, index|
      OptionType.update_all(['position=?', index], ['id=?', id])
    end

    respond_to do |format|
      format.html { redirect_to admin_product_variants_url(params[:product_id]) }
      format.js  { render :text => 'Ok' }
    end
  end

  # AJAX method for selecting an existing option type and associating with the current product
  def select
    @product = Product.find_by_param!(params[:product_id])
    product_option_type = ProductOptionType.new(:product => @product, :option_type => OptionType.find(params[:id]))
    product_option_type.save
    @product.reload
    @option_types = @product.option_types
    set_available_option_types
  end

  protected

    def location_after_save
      if @option_type.created_at == @option_type.updated_at
        edit_admin_option_type_url(@option_type)
      else
        admin_option_types_url
      end
    end


  private
    def load_product
      @product = Product.find_by_param!(params[:product_id])
    end

    def set_available_option_types
      @available_option_types = OptionType.all
      selected_option_types = []
      @product.options.each do |option|
        selected_option_types << option.option_type
      end
      @available_option_types.delete_if {|ot| selected_option_types.include? ot}
    end
end
