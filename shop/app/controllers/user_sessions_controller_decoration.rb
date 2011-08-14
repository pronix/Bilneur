UserSessionsController.class_eval do
  include Spree::CurrentVirtualOrder
  helper_method :current_virtual_order

  private
  def associate_user
    return unless current_user and (current_order || current_virtual_order)
    current_order.associate_user!(current_user) if current_order
    current_virual_order.associate_user!(current_user) if current_virual_order
    session[:guest_token] = nil
  end

end
