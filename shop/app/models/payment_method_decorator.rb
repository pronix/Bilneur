PaymentMethod.class_eval do
  class << self

    def paypal(display_on = 'both')
      PaymentMethod.all.find{|v|
        (v.name == "PayPal") && (Rails.env == v.environment || v.environment.blank? )  &&
        (v.display_on == display_on.to_s || v.display_on.blank?)  }
    end

    def vpaypal(display_on = 'both')
      PaymentMethod.all.find{|v|
        (v.name == "vPayPal") && (Rails.env == v.environment || v.environment.blank? )  &&
        (v.display_on == display_on.to_s || v.display_on.blank?)  }
    end


    def credit_card(display_on = 'both')
      PaymentMethod.all.find{|v|
        (v.name == "Credit Card") && (Rails.env == v.environment || v.environment.blank? )  &&
        (v.display_on == display_on.to_s || v.display_on.blank?)  }
    end

  end
end
