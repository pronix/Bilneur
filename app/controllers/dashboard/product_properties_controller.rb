class Dashboard::ProductPropertiesController < Dashboard::ApplicationController
  before_filter :load_data

  private

  def load_data
    @product = Product.find_by_permalink(params[:product_id])
    @properties = Property.all.map(&:name)
  end
end
