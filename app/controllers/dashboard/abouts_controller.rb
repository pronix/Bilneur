class Dashboard::AboutsController < Dashboard::ApplicationController
  before_filter :load_and_authorize_resource
  before_filter :if_new, :only => :edit

  def edit
    @about = @current_user.about
  end

  def update
    if @current_user.about.present?
      @current_user.about.update_attributes(params[:about])
    else
      @current_user.create_about(params[:about])
    end
    flash.notice = "Your abouts are saved"
    redirect_to dashboard_account_path
  end

  private

  def if_new
    @about = @current_user.build_about if @current_user.about.nil?
  end

  def load_and_authorize_resource
    authorize! :access, :about
  end

end

