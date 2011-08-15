class SellerReview < ActiveRecord::Base
  belongs_to :order
  belongs_to :seller, :class_name => "User"
  belongs_to :buyer, :class_name => "User"

  class << self
    def build(order, buyer, params = { })
      new(params.merge({ :order => order, :buyer => buyer, :seller => order.seller }))
    end
  end

end
