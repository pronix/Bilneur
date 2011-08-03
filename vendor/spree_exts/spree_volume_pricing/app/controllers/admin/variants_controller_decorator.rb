Admin::VariantsController.class_eval do
  before_filter :check_volume_prices_attributes, :only => [:volume_prices]

  def load_resource_instance
    parent
    Variant.find(params[:id])
  end

  def volume_prices
    @product = @variant.product
  end

  private
  def check_volume_prices_attributes
    params[:variant][:volume_prices_attributes] ||= {}
  end
end
