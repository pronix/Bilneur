UserSessionsController.class_eval do

  private

  # Back to original
  #
  # def redirect_back_or_default(default)
  #   unless (session["user_return_to"]||default).to_s =~ /cart|checkout|order/
  #     redirect_to( dashboard_root_path )
  #   else
  #     redirect_to(session["user_return_to"] || default)
  #   end
  #   session["user_return_to"] = nil
  # end


  def associate_user
    return unless current_user and (current_order || current_virtual_order)
    current_order.associate_user!(current_user) if current_order
    current_virtual_order.associate_user!(current_user) if current_virtual_order
    session[:guest_token] = nil
    current_user.merge_favorite(session[:favorite_products]||[])
    session[:favorite_products] = [ ]

  end

end
