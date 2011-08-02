class Dashboard::QuotesController < Dashboard::ApplicationController
  before_filter :load_and_authorize_resource

  def index

  end

  def new
    if (@product = Product.find_by_permalink(params[:product_permalink]))
      @quote = @product.variants.new
    else
      redirect_to dashboard_quotes_path, :notice => I18n.t("product_not_found")
    end
  end

  def search
    if (@product = Product.find_by_ean(params[:ean]))
      redirect_to new_dashboard_quote_path(@product.permalink)
    else
      redirect_to new_dashboard_product_path
    end
  end

  def load_and_authorize_resource
    authorize! :access, :quote
  end

end
