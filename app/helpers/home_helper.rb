module HomeHelper
  def start_selling_link
    # Link state. 
    # If non register -> register with checkbox as_seller
    # If register and has role user -> account page and add role sale
    # If already saller role -> now is root_path letter to create product
    return new_user_registration_path(:as_seller => true) if !current_user
    return account_path(:as_seller => true) if current_user.has_role?("user") && ! current_user.has_role?("seller")
    return root_path if current_user.has_role?("seller")
  end

end
