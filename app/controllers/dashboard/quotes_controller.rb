class Dashboard::QuotesController < Dashboard::ApplicationController
  before_filter :load_and_authorize_resource

  def index

  end

  def load_and_authorize_resource
    authorize! :access, :quote
  end

end
