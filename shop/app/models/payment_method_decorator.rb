PaymentMethod.class_eval do
  class << self

    def paypal(display_on = 'both')
      all.select { |p|
        p.active &&
        (p.display_on == display_on.to_s || p.display_on.blank?) &&
        (p.environment == Rails.env || p.environment.blank?)
      }.detect{ |v| v.name = "PayPal" }

    end

    def credit_card(display_on = 'both')
      all.select { |p|
        p.active &&
        (p.display_on == display_on.to_s || p.display_on.blank?) &&
        (p.environment == Rails.env || p.environment.blank?)
      }.detect{ |v| v.name = "Credit Card" }

    end

  end
end
