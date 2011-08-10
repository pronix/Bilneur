UserRegistrationsController.class_eval do

  protected

  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.has_role?("seller")
      dashboard_quotes_path
    else
      super
    end
  end

  # def sign_in_and_redirect(resource__or_scope, user)
  #   if user.has_role?("seller")

  #   else
  #     super
  #   end
  # end
  def associate_user
    return unless current_user and (current_order || current_virtual_order)
    current_order.associate_user!(current_user) if current_order
    current_virtual_order.associate_user!(current_user) if current_virtual_order
    session[:guest_token] = nil
  end

end
