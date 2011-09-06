LineItem.class_eval do
  has_one :user, :through => :order

  after_validation  :hack_after_validate
  validates :quantity, :numericality => {
    :only_integer => true,
    :message => I18n.t("validation.must_be_int")
  }

  validate :quantity_product,                :if => lambda{ |t| t.variant.present? && !t.order.group_sale? }
  validate :quantity_product_for_group_sale, :if => lambda{ |t| t.variant.present? && t.order.group_sale?  }

  after_save :load_sellers # refresh all sellers on order
  after_destroy :load_sellers

  def quantity_product
    if quantity.to_i < 0
      errors[": \"#{variant.name}\""] ||= []
      errors[": \"#{variant.name}\""] << " quantity must be greater than 0"
    end

    # Line items quantity must be non-decimal number
    if quantity > variant.count_on_hand
      errors[": \"#{variant.name}\""] ||= []
      errors[": \"#{variant.name}\""] << "quantity must be less than or equal to #{variant.count_on_hand}"
    end
  end

  def quantity_product_for_group_sale
    if quantity > order.group_sale.try(:avaliable_quantity).to_i
      errors[": \"#{variant.name}\""] ||= []
      errors[": \"#{variant.name}\""] << "quantity must be less than or equal to #{order.group_sale.avaliable_quantity}"
    end
  end

  def hack_after_validate #:nodoc:
    errors[:quantity].reject!{|v| v.to_s =~ /translation missing/ }
    errors[:quantity].uniq!
  end

  def load_sellers
    order.sellers!
  end

end
