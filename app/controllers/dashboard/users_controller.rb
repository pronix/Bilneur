class Dashboard::UsersController < Dashboard::ApplicationController
  before_filter :change_user_2_saller, :only => :show

  def show
  end

  protected

  def change_user_2_saller
    if params[:as_seller] and !current_user.has_role?('seller')
      current_user.set_seller_role!
      flash.notice = 'You are a sallers now'
    end
  end

end
