ProductsController.class_eval do
  def show
    @product = Product.find_by_permalink!(params[:id])
    raise ActiveRecord::RecordNotFound unless @product
    raise ActiveRecord::RecordNotFound unless @product.best_variant

    @best_variant = @product.best_variant

    @variants = Variant.active.includes([:option_values, :images]).where(:product_id => @product.id)
    @product_properties = ProductProperty.includes(:property).where(:product_id => @product.id)
    @selected_variant = @variants.detect { |v| v.available? }

    referer = request.env['HTTP_REFERER']

    if referer && referer.match(ProductsController::HTTP_REFERER_REGEXP)
      @taxon = Taxon.find_by_permalink($1)
    end

    respond_with(@product)
  end


end
