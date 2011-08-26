class FavoriteProductsController < Spree::BaseController
  # before_filter :authenticate_user!
  helper Spree::BaseHelper


  #
  #
  def add

    if (@variant = Variant.active.find_by_id(params[:id]))
      if current_user
        current_user.add_to_favorite(@variant)
      else
        (session[:favorite_products] ||= [ ]) << @variant.id
      end
    end
    respond_to do |format|
      format.html { redirect_to :back, :notice => "Product saved." }
      format.js  { render :partial => "order/favorite_product", :layout => false  }
    end


  end

  # Add variant to cart
  # {"quantity"=>"1",  "card"=>"normal", "id"=>"687951204"}
  #
  def cart
    if (@variant = Variant.active.find_by_id(params[:id]))
      @cart_order =  params[:cart].to_s == 'virtual' ? current_virtual_order(true) : current_order
      quantity = params[:quantity].to_i
      @cart_order.add_variant(@variant, quantity) if quantity > 0
    end
    redirect_to(:back) rescue redirect_to(cart_path)
  end


  # Remove variant from favorite products
  #
  def destroy

    if (@variant = Variant.active.find_by_id(params[:id]))
      if current_user
        current_user.remove_from_favorite(@variant)
      else
        (session[:favorite_products]||[]).delete(@variant.id)
      end
    end

    redirect_to(:back) rescue redirect_to(cart_path)

  end

end
