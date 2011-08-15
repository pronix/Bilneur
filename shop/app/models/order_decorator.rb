# customize the checkout state machine
Order.state_machines[:state] = StateMachine::Machine.new(Order, :initial => 'cart', :use_transactions => false) do

  event :next do
    transition :from => 'cart',     :to => 'address', :unless => :virtual?
    transition :from => 'cart',     :to => 'delivery', :if => :virtual?

    transition :from => 'address',  :to => 'delivery', :unless => :virtual?
    transition :from => 'delivery', :to => 'payment'
    transition :from => 'confirm',  :to => 'complete'


    # note: some payment methods will not support a confirm step
    transition :from => 'payment',  :to => 'confirm',
    :if => Proc.new { Gateway.current && Gateway.current.payment_profiles_supported? }

    transition :from => 'payment', :to => 'complete'
  end

  event :receive do
    transition :to => 'received', :from => 'complete'
  end


  event :cancel do
    transition :to => 'canceled', :if => :allow_cancel?
  end
  event :return do
    transition :to => 'returned', :from => 'awaiting_return'
  end
  event :resume do
    transition :to => 'resumed', :from => 'canceled', :if => :allow_resume?
  end
  event :authorize_return do
    transition :to => 'awaiting_return'
  end

  before_transition :to => 'complete' do |order|
    begin
      order.process_payments!
    rescue Spree::GatewayError
      if Spree::Config[:allow_checkout_on_gateway_error]
        true
      else
        false
      end
    end
  end

  # after_transition :to => 'complete', :do => :finalize!
  after_transition :to => 'complete', :do => :with_children_finalize!
  after_transition :to => 'delivery', :do => :create_tax_charge!
  after_transition :to => 'payment',  :do => :create_shipment!
  after_transition :to => 'canceled', :do => :after_cancel


end


Order.class_eval do
  attr_accessible :seller_shipping_method

  belongs_to :parent, :class_name => "Order"

  has_and_belongs_to_many :sellers, :join_table => "orders_users", :class_name => "User"
  has_and_belongs_to_many :shipping_methods, :join_table => "orders_shipping_methods", :class_name => "ShippingMethod"

  before_validation :set_email
  before_validation :fill_billing_address
  def set_email
    self.email ||= user.email if user.present?

  end

  def fill_billing_address
    if ship_address.present? && bill_address.blank?
      self.bill_address = ship_address.clone
    end
  end

  def multi_sellers?
    sellers.count > 1
  end

  def rate_hash_for_seller(user_seller)
    available_shipping_methods_for_seller(user_seller, :front_end).collect do |ship_method|
      next unless cost = ship_method.calculator.compute(self)
      { :id => ship_method.id,
        :shipping_method => ship_method,
        :name => ship_method.name,
        :cost => cost
      }
    end.compact.sort_by{|r| r[:cost]}
  end

  # default_scope where(:virtual => false)

  def has_available_shipment
    return unless :address == state_name.to_sym
    return unless ship_address && ship_address.valid?
    sellers.each do |seller|
      errors[": #{seller.full_name} - no available shipping method"] if available_shipping_methods_for_seller(seller).empty?
      # errors.add(:base, :no_shipping_methods_available) if sellers.present? && available_shipping_methods.empty?
    end

  end

  def available_shipping_methods(display_on = nil)
    return [ ] if !virtual? && !ship_address
    ShippingMethod.all_available(self, display_on)
  end


  def available_shipping_methods_for_seller(user_seller, display_on = nil)
    return [ ] if !virtual? && !ship_address
    return [ ] if user_seller.shipping_methods.blank?
    if virtual?
      user_seller.shipping_methods.virtual.select { |method| method.available_to_order?(self, display_on)}
    else
      user_seller.shipping_methods.realy.select { |method| method.available_to_order?(self, display_on)}
    end
  end


  def create_shipment!
    shipping_methods.reload

    shipping_methods.each do |item|
     if (_shipment = shipments.find_by_shipping_method_id(item.id))
       _shipment.update_attributes(:shipping_method => item, :seller => item.seller)
     else
       self.shipments << Shipment.create(:order => self, :seller => item.seller, :shipping_method => item,
                                         :address => self.ship_address)
     end
    end

  end

  def with_children_finalize!
    set_user_as_virtual_buyer!
    sellers.each { |v| OrderMailer.confirm_email_to_seller(self,v).deliver }
    finalize!
  end

  def seller_shipping_method=(attrs)
    self.shipping_methods.clear
    attrs.each do |ship_seller_id, shipment_attrs|
      user_seller = sellers.find(ship_seller_id)
      self.shipping_methods << user_seller.shipping_methods.find(shipment_attrs[:shipping_method_id])
    end

  end

  def total(user_seller = nil)
    read_attribute(:total)
  end


  # Add virtual_buyer if order is virtual
  #
  def set_user_as_virtual_buyer!
    user.roles << Role.find_or_create("virtual_buyer") if virtual? && user.has_role?("virtual_buyer")
  end


  def allowed_receive?
    complete? && payment_state == 'paid'
  end

  class << self

  end # end class << self

end
