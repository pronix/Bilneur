UsersController.class_eval do
  def create
    @user = User.new(params[:user])
    if @user.save

      if current_order || current_virtual_order
        current_order.associate_user!(@user) if current_order
        current_virtual_order.associate_user!(@user) if current_virtual_order
        session[:guest_token] = nil
      end

      redirect_back_or_default(root_url)
    else
      render 'new'
    end

  end

end
