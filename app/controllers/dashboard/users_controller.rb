class Dashboard::UsersController < Dashboard::ApplicationController

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

end
