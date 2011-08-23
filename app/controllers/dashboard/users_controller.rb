class Dashboard::UsersController < Dashboard::ApplicationController
  before_filter :change_user_2_saller, :only => :show

  def show
  end

  def edit
  end

  def update
    if current_user.update_attributes(params[:user])
      flash.notice = "Account updated."
    end
    redirect_to dashboard_account_path
  end

  def upload_photo
    if request.put?
      if @current_user.update_attributes(params[:user])
        redirect_to dashboard_account_path
        flash.notice = "Photo updated"
      else
        render :upload_photo
      end
    end
  end

  def change_password
    if request.put?
      if @current_user.update_with_password(params[:user])
        sign_in(@current_user, :bypass => true)
        flash.notice = 'Password updated.'
        redirect_to dashboard_account_path
      else
        render :action => :change_password
      end
    end
  end

  protected

  def change_user_2_saller
    if params[:as_seller] and !current_user.has_role?('seller')
      current_user.set_seller_role!
      flash.notice = 'You are a sallers now'
    end
  end

end
