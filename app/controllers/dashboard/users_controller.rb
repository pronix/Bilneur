class Dashboard::UsersController < Dashboard::ApplicationController
  before_filter :change_user_2_saller, :only => :show

  helper Admin::BaseHelper
  helper Admin::NavigationHelper

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

  def change_password
    if current_user.update_attributes(params[:user])
      flash.notice = "Password update"
    else
      render :change_password
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
