class Dashboard::UsersController < Dashboard::ApplicationController

  def show

  end

  def edit
  end

  def update
    redirect_to dashboard_account_path
  end

end
