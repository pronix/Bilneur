UserRegistrationsController.class_eval do
  protected

  def associate_user
    return unless current_user and (current_order || current_virtual_order)
    current_order.associate_user!(current_user) if current_order
    current_virtual_order.associate_user!(current_user) if current_virtual_order
    session[:guest_token] = nil
  end

end
