class SellerPaymentMethod::CreditCard < SellerPaymentMethod
  preference :card_type,        :string
	preference :code,             :string
  preference :expiration,       :string
  preference :cvv,              :string
  preference :billing_address,  :string
end
