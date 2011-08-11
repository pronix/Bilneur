class SellerPaymentMethod::BankAccount < SellerPaymentMethod
	preference :bank, :string
	preference :routing_number, :string
	preference :account_number, :string
end
