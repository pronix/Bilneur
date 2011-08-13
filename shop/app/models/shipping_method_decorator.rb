ShippingMethod.class_eval do
  belongs_to :seller, :class_name => "User"
  scope :virtual, where(:virtual => true)
  scope :realy,   where(:virtual => false)

  def available_to_order?(order, display_on=nil)
    availability_check = available?(order,display_on)
    zone_check = order.virtual? ? true : (zone && zone.include?(order.ship_address))
    availability_check && zone_check
  end


  class << self

    def all_available(order, display_on=nil)
      order.seller.shipping_methods.select { |method| method.available_to_order?(order,display_on)}
    end

  end # end class << self
end
