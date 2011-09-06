class Dashboard::QuotesController < Dashboard::ApplicationController
  before_filter :load_and_authorize_resource
  before_filter :load_product, :only => [:create, :new, :destroy]
  respond_to :html, :js

  def index
    states = {"merchant" => :warehouse_merchant,
              "bilneur" => :warehouse_bilneur,
              "other" => :warehouse_seller }
    quotes = current_user.quotes.where(:deleted_at => nil)
    @quotes = states.key?(params[:state].to_s) ? quotes.send(states[params[:state]]) : quotes
    meta_search
  end


  def new
    if @product
      @quote = @product.variants.new
    else
      redirect_to dashboard_quotes_path, :notice => I18n.t("product_not_found")
    end
  end

  # Current user auto added to quote, see /shop/app/models/variant_decorator.rb: set_seller
  #
  def create
    @quote = @product.variants.new(params[:variant])
    if @quote.save
      redirect_to edit_dashboard_quote_path(@quote), :notice => "New quote added."
    else
      render :new
    end
  end

  def edit
    @quote = current_user.quotes.find(params[:id])
  end

  def options
    @quote = current_user.quotes.find(params[:id])
  end

  def update
    @quote = current_user.quotes.find(params[:id])

    if @quote.update_attributes(params[:variant])
      update_quote_options! if params.has_key?(:quote_options)
      redirect_to edit_dashboard_quote_path(@quote), :notice => "Quote updated."
    else
      render :edit
    end

  end

  # Destroy or delete mark
  #
  def destroy
    @quote = current_user.quotes.find(params[:id])
    if @quote.mark_deletion!
      flash.notice = I18n.t("quote_deleted")
    else
      flash.notice = I18n.t("quote_not_deleted")
    end
    redirect_to dashboard_quotes_path
  end

  # Search product on EAN
  #
  def search
    if (@product = Product.find_by_ean(params[:ean]))
      redirect_to new_dashboard_quote_path(params[:ean])
    else
      redirect_to new_dashboard_product_path
    end
  end

  private

  def meta_search
    params[:select_by] = "" if params[:select_by] == "all_active"
    params[:search] ||= {}
    @search = @quotes.metasearch(params[:search].merge({ :product_name_or_product_ean_contains => params[:search_string], :warehouse_eq => params[:select_by] }))
    @quotes = @search.paginate(paginate_options)
  end

  def load_and_authorize_resource
    authorize! :access, :quote
  end

  def load_product
    @product ||= Product.find_by_ean(params[:product_ean])
  end
  def update_quote_options!
    quote_options = [ ]
    product_options = @quote.product.option_types
    params[:quote_options].each do |option_type_id, option_value_id|
      option_type = product_options.find(option_type_id)
      option_value = option_type.option_values.find(option_value_id)
      quote_options << option_value
    end
    @quote.option_values = quote_options
  end
end

