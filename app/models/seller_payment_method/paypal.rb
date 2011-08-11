class SellerPaymentMethod::Paypal < SellerPaymentMethod
	preference :login, :string
	preference :password, :string
end
