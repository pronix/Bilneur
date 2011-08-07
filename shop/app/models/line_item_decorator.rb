LineItem.class_eval do
  has_one :user, :through => :order
  after_validation  :hack_after_validate
  validates :quantity, :numericality => {
    :only_integer => true,
    :message => I18n.t("validation.must_be_int")
  }

  validate :quantity_product

  def quantity_product

    if quantity.to_i <= 0
      errors[": \"#{variant.name}\""] ||= []
      errors[": \"#{variant.name}\""] << " quantity must be greater than 0"
    end

    # Line items quantity must be non-decimal number
    if quantity > variant.count_on_hand
      errors[": \"#{variant.name}\""] ||= []
      errors[": \"#{variant.name}\""] << "quantity must be less than or equal to #{variant.count_on_hand}"
    end
  end

  def hack_after_validate #:nodoc:
    errors[:quantity].reject!{|v| v.to_s =~ /translation missing/ }
    errors[:quantity].uniq!
  end


end
