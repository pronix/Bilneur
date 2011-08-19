Address.class_eval do

  after_create :set_primary!, :if => lambda{ |t| t.user.present? && t.user.addresses.primary.first.blank? }
  scope :primary, where(:primary => true)

  def set_primary!
    update_attribute(:primary, true)
  end

end
