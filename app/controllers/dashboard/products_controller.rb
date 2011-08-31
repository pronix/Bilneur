class Dashboard::ProductsController < Dashboard::ApplicationController
  helper Admin::BaseHelper
  helper Admin::NavigationHelper
  before_filter :find_product, :only => [:edit, :update]
  before_filter :prepare_taxon, :only => :wizard
  respond_to :html, :js, :json, :only => :wizard
  helper_method :set_available_option_types

  def index
    @products = Product.active.paginate(:per_page => 1, :page => params[:page], :order => "created_at DESC")
  end

  #
  #
  def wizard
    @product = params[:id].present? ? current_user.products.find(params[:id]) : current_user.products.new
    set_available_option_types if @product.creation_options?

    if params[:product].present? && @product.update_attributes(params[:product])
      @product.next_creation!
      @taxons = Hash.new {|h, k| h[k] = []}
    end

    respond_with(@product, :location => wizard_dashboard_products_path(@product.creation_state))
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
    redirect_to wizard_dashboard_products_path(@product.creation_state, @product.id) and return unless @product.creation_complete?
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

  def prepare_taxon
    if (@taxon_ids = params[:product].try(:[], :taxon_ids))
      params[:product][:taxon_ids] = [ @taxon_ids.last ].flatten
    end
  end

  def find_product
    @product = (current_user.is_admin? ? Product : current_user.products).find_by_permalink(params[:id])
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
