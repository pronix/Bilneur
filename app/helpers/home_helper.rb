module HomeHelper
  def start_selling_link
    # Chose what link we display fro non registered user, registerd and saller
    # TODO: Fix it's ugly code
    return link_to image_tag('forms/strt_slng_btn.png'), new_user_registration_path(:as_seller => true), :class => "btn" if !current_user
    if current_user.has_role?("seller")
      link = '/adsdsadasda'
    elsif current_user.has_role?("user") && ! current_user.has_role?("seller")
      link = account_path(:as_seller => true)
    else
      link new_user_registration_path(:as_seller => true)
    end
    link_to image_tag('forms/strt_slng_btn.png'), link, :class => "btn"
  end

end
