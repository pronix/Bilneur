Spree::BaseHelper.class_eval do

  def link_to_cart(text = t('cart'))
    return "" if current_page?(cart_path)
    text_cart = ""
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
      text_cart << "#{text} Cart: (#{order_count_items.first}) #{order_count_items.last}" if order_count_items
      text_cart << "<br /> V.Store: (#{virtual_order_count_items.first}) #{virtual_order_count_items.last}" if virtual_order_count_items
      css_class = 'full crt'
    else
      css_class = 'empty crt'
    end

    link_to raw(text_cart), cart_path, :class => css_class
  end

  def check_ass_seller_checkbox
    return true if params[:as_seller]
    true if params[:user][:registration_as_seller] == '1' rescue return false
  end

end
