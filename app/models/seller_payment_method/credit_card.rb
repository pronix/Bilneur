class SellerPaymentMethod::CreditCard < SellerPaymentMethod
	preference :code,             :string
  preference :expiration_month, :string
  preference :expiration_year,  :string
  preference :cvv,              :string
  preference :billing_address,  :string
end
