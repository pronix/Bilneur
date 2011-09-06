class Dashboard::ProductsController < Dashboard::ApplicationController
  helper Admin::BaseHelper
  helper Admin::NavigationHelper
  before_filter :find_product, :only => [:edit, :update]
  before_filter :prepare_taxon, :only => :wizard
  respond_to :html, :js, :json, :only => :wizard
  helper_method :set_available_option_types

  def index
    collection
  end

  #
  #
  def wizard
    @product = params[:id].present? ? current_user.products.find(params[:id]) : current_user.products.new
    set_available_option_types if @product.creation_options?

    @quote = @product.variants.new
    
    if (params[:product].present? || params[:id].present?) && @product.update_attributes(params[:product]) && !@product.creation_complete?
      if @quote && !@product.creation_basic?
        @quote.update_attributes(params[:quote]) 
        Rails.logger.debug "DUUUUUUDE ITS A QUOTE #{@quote.inspect}"
      end
      @product.next_creation!
      @taxons = Hash.new {|h, k| h[k] = []}
    end

    @state = params[:state].present? ? params[:state] : @product.creation_state

    if @quote
      Rails.logger.debug "DUUUUUUDE ITS A QUOTE #{@quote.inspect}"
    end

    respond_with(@product, :location => wizard_dashboard_products_path(@state))
  end

  def new
    @product = current_user.products.new
  end

  def create
    @product = current_user.products.new(params[:product])
    if @product.save
      flash.notice = "Product is created."
      render :edit
    else
      render :new
    end
  end

  def edit
    # redirect_to wizard_dashboard_products_path(@product.creation_state, @product.id) and return unless @product.creation_complete?
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

  def collection
    params[:search] ||= {}
    @search = case params[:select_by]
                when 'by_name' then Product.active.metasearch(:name_contains => params[:search_string])
                when 'by_sku' then Product.active.metasearch(:variants_including_master_sku_contains => params[:search_string])
                else @search = Product.active.metasearch(params[:search])
              end
    @products = @search.paginate(paginate_options.merge({:order => "created_at DESC"}))
  end

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
