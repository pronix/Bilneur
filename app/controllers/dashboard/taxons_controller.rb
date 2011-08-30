class  Dashboard::TaxonsController < Dashboard::ApplicationController
  helper Admin::TaxonsHelper

  include Railslove::Plugins::FindByParam::SingletonMethods

  respond_to :html, :json, :js


  def selected
    @product = load_product
    @taxons = @product.taxons

    respond_with(:admin, @taxons)
  end

  def available
    @product = load_product
    @taxons = params[:q].blank? ? [] : Taxon.where('lower(name) LIKE ?', "%#{params[:q].mb_chars.downcase}%")
    @taxons.delete_if { |taxon| @product.taxons.include?(taxon) }

    respond_with(:admin, @taxons)
  end

  def remove
    @product = load_product
    @taxon = Taxon.find(params[:id])
    @product.taxons.delete(@taxon)
    @product.save
    @taxons = @product.taxons

    respond_with(@taxon) { |format| format.js { render_js_for_destroy } }
  end

  def select
    @product = load_product
    @taxon = Taxon.find(params[:id])
    @product.taxons << @taxon
    @product.save
    @taxons = @product.taxons

    respond_with(:admin, @taxons)
  end

  def batch_select
    @product = load_product
    @taxons = params[:taxon_ids].map{|id| Taxon.find(id)}.compact
    @product.taxons = @taxons
    @product.save
    redirect_to selected_dashboard_product_taxons_url(@product)
  end

  def child
    @taxon = Taxon.find(params[:id])
    respond_with({ :taxon => @taxon,
                   :level => @taxon.level,
                   :children => @taxon.try(:children)
                 })
  end

  private

  def load_product
    Product.find_by_permalink! params[:product_id]
  end

end
