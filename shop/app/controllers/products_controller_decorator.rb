ProductsController.class_eval do
  respond_to :html, :js

  # Show the product page
  #
  def show
    load_data_for_product
    respond_with(@product)
  end

  # Show a sellers quote
  #  Parameters: {"product_id"=>"death-of-a-hero", "condition"=>"new"}
  #
  def quotes
    load_data_for_product
    respond_with(@product)
  end

  #  Parameters: {"product_id"=>"death-of-a-hero", "id"=>"8732"}
  #
  def quote
  end

  def like_review
    if request.xhr?
      Review.find(params[:id]).feedback_reviews.create(:rating => 1)
      respond_to do |format|
        format.json { render :json => { :status => 'ok' }, :status => :created }
      end
    end
  end

  private


  def load_data_for_product
    @product = Product.find_by_permalink!(params[:id])
    raise ActiveRecord::RecordNotFound unless @product
    raise ActiveRecord::RecordNotFound unless @product.best_variant
    @reviews = @product.reviews.paginate_reviews(params[:page])
    @recomends_count = @product.recomends_count

    @best_variant = @product.best_variant

    @variants = Variant.active.includes([:option_values, :images]).where(:product_id => @product.id)
    @product_properties = ProductProperty.includes(:property).where(:product_id => @product.id)
    @selected_variant = @variants.detect { |v| v.available? }

    referer = request.env['HTTP_REFERER']

    if referer && referer.match(ProductsController::HTTP_REFERER_REGEXP)
      @taxon = Taxon.find_by_permalink($1)
    end

  end
end
