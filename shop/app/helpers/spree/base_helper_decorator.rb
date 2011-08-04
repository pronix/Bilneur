Spree::BaseHelper.class_eval do
  def link_to_cart(text = t('cart'))
    return "" if current_page?(cart_path)
    css_class = nil
    if current_order.nil? or current_order.line_items.empty?
      # text = "#{text}: (#{t('empty')})"
      css_class = 'empty crt'
    else
      text = "#{text}: (#{current_order.item_count}) #{order_price(current_order)}"
      css_class = 'full crt'
    end
    link_to raw(text), cart_path, :class => css_class
  end

  def check_ass_seller_checkbox
    return true if params[:as_seller]
    true if params[:user][:registration_as_seller] == '1' rescue return false
  end

end
