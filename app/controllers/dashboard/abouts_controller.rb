class Dashboard::AboutsController < Dashboard::ApplicationController
  before_filter :load_and_authorize_resource
  before_filter :if_new, :only => :edit

  def edit
    @static_data = @current_user.static_data
  end

  def update
    if @current_user.static_data.present?
      @current_user.static_data.update_attributes(params[:static_data])
    else
      @current_user.create_static_data(params[:static_data])
    end
    flash.notice = "Your abouts are saved"
    redirect_to dashboard_account_path
  end

  private

  def if_new
    @about = @current_user.build_static_data if @current_user.static_data.nil?
  end

  def load_and_authorize_resource
    authorize! :access, :static_data
  end

end

