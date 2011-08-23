class Dashboard::AboutsController < Dashboard::ApplicationController
  before_filter :load_and_authorize_resource

  def edit
  end

  def update
  end

  private

  def load_and_authorize_resource
    authorize! :access, :about
  end

end

