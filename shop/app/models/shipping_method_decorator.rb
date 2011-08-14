ShippingMethod.class_eval do
  METHOD_KIND_TO_ADDRESS  = "to_address"    # simple method
  METHOD_KIND_TO_BILNEUR  = "to_bilneur"    # shipped to bilneur warehouse
  METHOD_KIND_WITH_SELLER = "with_seller"   # no shipped, store the product

  belongs_to :seller, :class_name => "User"
  scope :virtual, where(:virtual => true)
  scope :realy,   where(:virtual => false)
  [METHOD_KIND_TO_ADDRESS, METHOD_KIND_TO_BILNEUR, METHOD_KIND_WITH_SELLER ].each do |kind|
    scope kind.to_sym, where(:method_kind => kind)
  end
  def available_to_order?(order, display_on=nil)
    availability_check = available?(order,display_on)
    zone_check = order.virtual? ? true : (zone && zone.include?(order.ship_address))
    availability_check && zone_check
  end

  [METHOD_KIND_TO_ADDRESS, METHOD_KIND_TO_BILNEUR, METHOD_KIND_WITH_SELLER ].each do |kind|
    define_method "#{kind}?" do
      self.method_kind.to_s == kind.to_s
    end
  end

  # Creates a new adjustment for the target object (which is any class that has_many :adjustments) and
  # sets amount based on the calculator as applied to the calculable argument (Order, LineItems[], Shipment, etc.)
  # By default the adjustment will not be considered mandatory
  def create_adjustment(label, target, calculable, mandatory=false)
    amount = self.calculator.compute(calculable)
    target.adjustments.create(:amount => amount,  :source => calculable,
                              :originator => self,
                              :label => "#{label}(seller: #{seller.try(:full_name)})",
                              :mandatory => mandatory)
  end



  class << self

    def all_available(order, display_on=nil)
      # seller.shipping_methods.select { |method| method.available_to_order?(order,display_on)}
      all.select { |method| method.available_to_order?(order,display_on)}
    end

  end # end class << self
end
