UserSessionsController.class_eval do

   def create
     authenticate_user!

     if user_signed_in?
       respond_to do |format|
        format.html {
          flash[:notice] = I18n.t("logged_in_succesfully")
          redirect_back_or_default(dashboard_account_path)
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

  # Bask to original
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

  end

end
