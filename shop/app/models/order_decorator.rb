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

  belongs_to :group_sale

  has_and_belongs_to_many :sellers, :join_table => "orders_users", :class_name => "User"
  has_and_belongs_to_many :shipping_methods, :join_table => "orders_shipping_methods", :class_name => "ShippingMethod"

  # before_validation :set_email
  before_validation :fill_billing_address

  has_many :seller_reviews


  # Scope
  #
  [ Order::OPERATION_TYPE_SIMPLE, Order::OPERATION_TYPE_GROUP,  Order::OPERATION_TYPE_AUCTION  ].
    each { |v| scope :"operation_type_#{v}", where(:operation_type => v)}

  def operation_type?(op)
    operation_type.to_s == op
  end

  def group_sale?
    operation_type?(Order::OPERATION_TYPE_GROUP)
  end

  def set_email
    self.email ||= user.email if user.present?
  end

  def fill_billing_address
    if !virtual? && ship_address.present? && bill_address.blank?
      default_bill_address = ship_address.clone
      default_bill_address.user = nil
      self.bill_address = default_bill_address
    end
  end

  # True if orders with more seller
  #
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

  def shipment_for_seller(_seller)
    shipments.find_by_seller_id(_seller.id)
  end

  def create_shipment!
    shipping_methods.reload
    shipments.clear
    shipping_methods.each do |item|
     if (_shipment = shipments.find_by_shipping_method_id(item.id))
       _shipment.update_attributes(:shipping_method => item, :seller => item.seller)
     else
       self.shipments << Shipment.create!(:order => self,
                                          :seller => item.seller,
                                          :shipping_method => item,
                                          :address => self.ship_address)
     end
    end

  end

  def with_children_finalize!
    set_user_as_virtual_buyer!
    sellers.each { |v| OrderMailer.confirm_email_to_seller(self,v).deliver }
    finalize!
  end

  # Finalizes an in progress order after checkout is complete.
  # Called after transition to complete state when payments will have been processed
  def finalize!
    update_attribute(:completed_at, Time.now)
    self.out_of_stock_items = InventoryUnit.assign_opening_inventory(self)
    # lock any optional adjustments (coupon promotions, etc.)
    adjustments.optional.each { |adjustment| adjustment.update_attribute("locked", true) }
    OrderMailer.confirm_email(self).deliver

    self.state_events.create({
      :previous_state => "cart",
      :next_state     => "complete",
      :name           => "order" ,
      :user_id        => (User.respond_to?(:current) && User.current.try(:id)) || self.user_id
    })

    if virtual?
      shipments.each do |item|
        if item.shipping_method.with_seller?
          item.ship! if item.can_ship?
          item.inventory_units.map{ |v| v.ship! if v.sold? } if item.shipped?
        end
      end
    end

  end

  def seller_shipping_method=(attrs)
    self.shipping_methods.clear
    self.shipments.clear
    adjustments.map{ |v| v.destroy if v.source_type == "Shipment" }

    attrs.each do |ship_seller_id, shipment_attrs|
      user_seller = sellers.find(ship_seller_id)
      self.shipping_methods << user_seller.shipping_methods.find(shipment_attrs[:shipping_method_id])
    end

  end

  # full order weight
  def weight(_seller = nil)
    if _seller.present?
      self.line_items.select{ |v| v.variant.seller == _seller }.map {|x| x.variant.weight*x.quantity }.sum
    else
      self.line_items.map {|x| x.variant.weight*x.quantity }.sum
    end
  end

  def total_for_seller(user_seller)
    item_total_for_seller(user_seller) + adjustments_total_for_seller(user_seller)
  end


  # Add virtual_buyer if order is virtual
  #
  def set_user_as_virtual_buyer!
    user.roles << Role.find_or_create("virtual_buyer") if virtual? && user.has_role?("virtual_buyer")
  end


  def allowed_receive?
    complete? && payment_state == 'paid'
  end

  def item_total_for_seller(seller)
    line_items.includes(:variant).map{|v| v.variant.seller == seller ? v.amount : 0 }.sum
  end

  def adjustments_total_for_seller(seller)
    adjustments.map{|v| v.seller == seller ? v.amount : 0 }.sum
  end

  def received?
    receive_at.present?
  end

  def sellers!
    self.seller_ids = line_items.reload.map {|v| v.variant.seller_id }.uniq
    save(:validate => false)
    return sellers
  end

  # Merge saved order with current and  associate user, and destroy donor order
  #
  def associate_user!(user)
    if (prev_order = ( virtual? ? user.virtual_orders : user.orders ).metasearch(:id_not_eq => self.id,
                                                                                 :state_not_eq => :complete).first )
      prev_order.line_items.each {  |v|  add_variant(v.variant, v.quantity) }
      prev_order.destroy
    end

    self.user = user
    self.email = user.email
    # disable validations since this can cause issues when associating an incomplete address during the address step
    save(:validate => false)
  end

  # Checked product quantity and update quantity in line_items
  #
  def check_product_quantity
    @results = [ ]
    line_items.each do |item|
      unless item.quantity <= item.variant.count_on_hand
        if item.variant.count_on_hand == 0
          @results << I18n.t("product_is_not_available", :name => item.variant.name)
          line_items.destroy(item)
        else
          @results << I18n.t("goods_in_stock", :name => item.variant.name, :quantity => item.variant.count_on_hand)
          item.quantity = item.variant.count_on_hand
          item.save
        end
      end

    end
    reload
    return @results
  end

  # Group Sales
  #

  def add_group_sale(_group_sale, _quantity)
    update_attribute(:group_sale_id, _group_sale.id)
    line_items.destroy_all

    item = LineItem.new(:quantity => _quantity)
    item.order = self
    item.variant = _group_sale.variant
    item.price   = _group_sale.price

    line_items << item
    save

  end

  #  end Group Sales


  class << self
    # Group Sales
    #

    def build_group_order(_user)
      order = create
      order.operation_type = Order::OPERATION_TYPE_GROUP
      order.associate_user!(_user)
      order
    end

    # end Group Sales
  end # end class << self

end
