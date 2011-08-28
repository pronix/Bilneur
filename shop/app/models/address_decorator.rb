Address.class_eval do

  after_create :primary! #, :if => lambda{ |t| t.user.present? && t.user.addresses.primary.first.blank? }

  scope :primary, where(:primary => true)

  def set_primary!

    update_attribute(:primary, true)
  end

  def primary!
    if user.present?
      user.addresses.update_all(:primary => false)
      set_primary!
    end
    self.reload
  end

  def full_name=(v)
    self.firstname, self.lastname = *v.to_s.strip.split(' ',2) unless v.blank?
  end

  def full_name
    "#{self.firstname} #{self.lastname}"
  end

end
