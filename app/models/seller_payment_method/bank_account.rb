class SellerPaymentMethod::BankAccount < SellerPaymentMethod
	preference :bank, :string
	preference :routing_no, :string
	preference :account_number, :string
end
