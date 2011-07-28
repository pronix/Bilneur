class Dashboard::ApplicationController < Spree::BaseController
  layout "dashboard"
  before_filter :authenticate_user!


end
