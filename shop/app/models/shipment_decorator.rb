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
  # after_transition :to => 'received', :do => :create_order_txn
end


Shipment.class_eval do
  belongs_to :seller, :class_name => "User"
  scope :received, where(:state => 'received')
end
