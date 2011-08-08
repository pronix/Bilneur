class ApplicationController < ActionController::Base
  protect_from_forgery
  include Spree::CurrentVirtualOrder
  helper_method :current_virtual_order

end
