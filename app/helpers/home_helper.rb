module HomeHelper
  def start_selling_link
    # Link state. 
    # If non register -> register with checkbox as_seller
    # If register and has role user -> account page and add role sale
    # If already saller role -> dashboard_quotes_path
    return new_user_registration_path(:as_seller => true) if !current_user
    return account_path(:as_seller => true) if current_user.has_role?("user") && ! current_user.has_role?("seller")
    return dashboard_quotes_path if current_user.has_role?("seller")
  end

  def link_to_cart(text = t('cart'))
    return "" if current_page?(cart_path)
    css_class = nil
    if current_order.nil? or current_order.line_items.empty?
      text = "#{text}: (#{t('empty')})"
      css_class = 'empty'
    else
      text = "#{text}: (#{current_order.item_count}) #{order_price(current_order)}"
      css_class = 'full'
    end
    link_to text, cart_path,
  end
end
