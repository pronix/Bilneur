class SellerPaymentMethod::CreditCart < SellerPaymentMethod
	preference :type_card, :string
	preference :number, :string
  preference :exp, :date
  preference :cvv, :string
  preference :billing_address_id, :integer
end
