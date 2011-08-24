UserSessionsController.class_eval do
  def create
    authenticate_user!

    if user_signed_in?
      respond_to do |format|
        format.html {
          flash[:notice] = I18n.t("logged_in_succesfully")
          redirect_to account_path #FIXME still redirect to products_path
        }
        format.js {
          user = resource.record
          render :json => {:ship_address => user.ship_address, :bill_address => user.bill_address}.to_json
        }
      end
    else
      flash[:error] = I18n.t("devise.failure.invalid")
      render :new
    end
  end

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
