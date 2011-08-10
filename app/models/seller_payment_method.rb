class SellerPaymentMethod < ActiveRecord::Base
  validates :name, :type, :presence => true
end
