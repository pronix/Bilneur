Address.class_eval do
  belongs_to :user

  before_validation :set_default_data

  def set_default_data
    if user && self.firstname.blank?
      self.firstname ||= user.firstname
      self.lastname  ||= user.lastname
    end
  end

  def self.required_fields
    validator = Address.validators.find{|v| v.kind_of?(ActiveModel::Validations::PresenceValidator)}
    validator ? validator.attributes : []
  end

  # can modify an address if it's not been used in an order
  def editable?
    new_record? || (shipments.empty? && (Order.where("bill_address_id = ?", self.id).count + Order.where("bill_address_id = ?", self.id).count <= 1) && Order.complete.where("bill_address_id = ? OR ship_address_id = ?", self.id, self.id).count == 0)
  end

  def can_be_deleted?
    shipments.empty? && Order.where("bill_address_id = ? OR ship_address_id = ?", self.id, self.id).count == 0
  end

  def to_s
    "#{firstname} #{lastname}: #{zipcode}, #{country}, #{state || state_name}, #{city}, #{address1} #{address2}"
  end

end
