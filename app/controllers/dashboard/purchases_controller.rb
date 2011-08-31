class Dashboard::PurchasesController < Dashboard::ApplicationController

  def index
    @orders = Order.unscoped.complete.where(:user_id => current_user.id).
      paginate(paginate_options.merge({  :order => "created_at"}))

  end

end
