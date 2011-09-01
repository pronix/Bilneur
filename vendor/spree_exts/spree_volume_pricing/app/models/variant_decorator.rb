Variant.class_eval do
  has_many :volume_prices, :order => :position, :dependent => :destroy
  accepts_nested_attributes_for :volume_prices, :allow_destroy => true

  # calculates the price based on quantity
  def volume_price(quantity)
    volume_prices.each do |price|
      return price.amount if price.include?(quantity)
    end
    self.price
  end

  def available_volume_prices(_quantity = count_on_hand)
    volume_prices.select { |v|
      (1.._quantity.to_i).include?(v.range_first)
    }
  end

end
