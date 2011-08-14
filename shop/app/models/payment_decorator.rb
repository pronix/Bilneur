Payment.state_machines[:state] = StateMachine::Machine.new(Payment, :initial => 'checkout') do
  # With card payments, happens before purchase or authorization happens
  event :started_processing do
    transition :from => ['checkout', 'pending', 'completed'], :to => 'processing'
  end
  # When processing during checkout fails
  event :fail do
    transition :from => 'processing', :to => 'failed'
  end
  # With card payments this represents authorizing the payment
  event :pend do
    transition :from => 'processing', :to => 'pending'
  end
  # With card payments this represents completing a purchase or capture transaction
  event :complete do
    transition :from => ['processing', 'pending'], :to => 'completed'
  end
  event :void do
    transition :from => ['pending', 'completed'], :to => 'void'
  end
  after_transition :to => 'completed', :do => :shipped_quote_if_store_with_seller
end
Payment.class_eval do

  def shipped_quote_if_store_with_seller

    if order.virtual?
      order.shipments.each do |item|
        item.ship! if item.shipping_method.with_seller?
      end
    end

  end

end
