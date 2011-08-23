class Dashboard::SellersController < Dashboard::ApplicationController
  before_filter :load_and_authorize_resource
  before_filter lambda{ redirect_to about_you_dashboard_sellers_path and return }, :only => :show
  before_filter :for_staic_data, :only => [:about_you, :return_policy]

  def show
  end

  def about_you
  end

  def return_policy
  end

  private

  def for_staic_data
    if request.put?
      if @current_user.static_data.present?
        @current_user.static_data.update_attributes(params[:static_data])
      else
        @current_user.create_static_data(params[:static_data])
      end
      flash.notice = "Your abouts are saved"
      redirect_to dashboard_account_path and return
    end
    @static_data = @current_user.static_data
  end

  def load_and_authorize_resource
    authorize! :access, :seller
  end
end
