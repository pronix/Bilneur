class VirtualOrder < Order
  if Order.table_exists?
    default_scope where(:virtual => true)
  end

  before_validation :set_default_data, :on => :create

  def set_default_data
    self.virtual = true
    self.user ||= User.current
  end

  def order
    Order.find_by_number(self.number)
  end
end
