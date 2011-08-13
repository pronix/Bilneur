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
  after_transition :to => 'delivery', :do => :division_on_seller_order!
  after_transition :to => 'payment',  :do => :with_children_create_shipment!
  after_transition :to => 'canceled', :do => :after_cancel


end


Order.class_eval do
  attr_accessible :children_orders

  belongs_to :seller, :class_name => "User"
  belongs_to :parent, :class_name => "Order"
  has_many   :children, :foreign_key => "parent_id", :class_name => "Order"

  before_validation :set_email

  def set_email
    self.email ||= user.email if user.present?
  end

  # default_scope where(:virtual => false)

  def has_available_shipment
    return unless :address == state_name.to_sym
    return unless ship_address && ship_address.valid?
    errors.add(:base, :no_shipping_methods_available) if seller.present? && available_shipping_methods.empty?
  end

  def available_shipping_methods(display_on = nil)
    return [ ] if !virtual? && !ship_address
    return [ ] if seller.shipping_methods.blank?
    if virtual?
      seller.shipping_methods.virtual.select { |method| method.available_to_order?(self, display_on)}
    else
      seller.shipping_methods.realy.select { |method| method.available_to_order?(self, display_on)}
    end
  end


  def with_children_create_shipment!
    children.present? ? children.map( &:create_shipment!) : create_shipment!
  end

  def with_children_finalize!
    set_user_as_virtual_buyer!
    if children.present?
      children.map{ |v|
        v.payments = self.payments
        v.save
        v.next
      }
      children.map &:next
    else
      OrderMailer.confirm_email_to_seller(self).deliver
      finalize!
    end
  end

  def children_orders=(attrs)
    attrs.each do |k, v|
      @_order = children.find(k)
      @_order.update_attributes(v)
      unless @_order.next
        self.errors[:shippings] << @_order.errors
      end
    end

  end
  def total
    if children.present?
      children.sum(:total)
    else
      read_attribute(:total)
    end
  end

  # Add virtual_buyer if order is virtual
  #
  def set_user_as_virtual_buyer!
    user.roles << Role.find_or_create("virtual_buyer") if virtual? && user.has_role?("virtual_buyer")
  end

  # Separating on sub orders for each seller
  #
  def division_on_seller_order!
    children.destroy_all

    if (@sellers = line_items.map {|v| v.variant.seller }.uniq ) && @sellers.count > 1
      @sellers.each do |ss|
        @clone_order        = self.clone
        @clone_order.number = nil
        @clone_order.seller = ss
        @clone_order.parent = self
        @clone_order.hidden = true

        if @clone_order.save
          self.line_items.each do |item|
            @clone_order.line_items << item.clone if item.variant.seller == ss
          end
        end

      end
    else
      self.seller = line_items.first.variant.seller
      save!
    end

  end

  def allowed_receive?
    complete? && payment_state == 'paid'
  end

  class << self

  end # end class << self

end
