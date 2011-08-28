Spree::BaseHelper.class_eval do

  def link_to_cart(text = t('cart'))
    return "" if current_page?(cart_path) || (current_order.try(:line_items).blank? && current_virtual_order.try(:line_items).blank?)
    css_class = nil
    order_count_items = if current_order.nil? or current_order.line_items.empty?
                          nil
                        else
                          [ current_order.reload.item_count, order_price(current_order) ]
                        end

    virtual_order_count_items = if current_virtual_order.nil? or current_virtual_order.line_items.empty?
                                  nil
                                else
                                  [ current_virtual_order.reload.item_count, order_price(current_virtual_order) ]
                                end

    if order_count_items || virtual_order_count_items
      if virtual_order_count_items
        css_class = 'full crt vstore'
      else
        css_class = 'full crt'
      end
    else
      css_class = 'empty crt'
    end

    link_to raw(text), cart_path, :class => css_class
  end

  def check_ass_seller_checkbox
    return true if params[:as_seller]
    true if params[:user][:registration_as_seller] == '1' rescue return false
  end


  def is_favorite?(variant)
    if current_user.favorite_variants.find_by_id(variant.id)
      true
    else
      false
    end
  end

end
