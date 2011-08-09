UserSessionsController.class_eval do
  private
  def associate_user
    return unless current_user and (current_order || current_virtual_order)
    current_order.associate_user!(current_user) if current_order
    current_virual_order.associate_user!(current_user) if current_virual_order
    session[:guest_token] = nil
  end

end
