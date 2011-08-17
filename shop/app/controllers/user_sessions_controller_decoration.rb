UserSessionsController.class_eval do
  private
  def associate_user
    return unless current_user and (current_order || current_virtual_order)
    current_order.associate_user!(current_user) if current_order
    current_virtual_order.associate_user!(current_user) if current_virtual_order
    session[:guest_token] = nil

    puts "="*90
    puts current_user.inspect
    puts current_order.inspect
    puts current_virtual_order.inspect
    puts "="*90

  end

end
