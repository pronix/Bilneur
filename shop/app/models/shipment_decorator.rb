Shipment.state_machines[:state] =
  StateMachine::Machine.new(Shipment, :initial => 'pending', :use_transactions => false) do

  event :ready do
    transition :from => 'pending', :to => 'ready'
  end

  event :pend do
    transition :from => 'ready', :to => 'pending'
  end

  event :ship do
    transition :from => 'ready', :to => 'shipped'
  end

  event :receiving do
    transition :from => 'shipped', :to => 'received'
  end

  after_transition :to => 'shipped', :do => :after_ship
  after_transition :to => 'received', :do => :receive_order
end


Shipment.class_eval do
  belongs_to :seller, :class_name => "User"
  scope :received, where(:state => 'received')

  def receive_order
    update_attribute(:receive_at, Time.now)
  end

  # Determines the appropriate +state+ according to the following logic:
  #
  # pending    unless +order.payment_state+ is +paid+
  # shipped    if already shipped (ie. does not change the state)
  # ready      all other cases
  def determine_state(order)
    return "pending" if self.inventory_units.any? {|unit| unit.backordered?}
    return "shipped" if state == "shipped"
    order.payment_state == "balance_due" ? "pending" : (self.received? ? "received" : "ready")
  end

end
