ShippingMethod.class_eval do
  belongs_to :seller, :class_name => "User"

  class << self

    def all_available(order, display_on=nil)
      order.seller.shipping_methods.select { |method| method.available_to_order?(order,display_on)}
    end

  end # end class << self
end
