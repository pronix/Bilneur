class SellerPaymentMethod < ActiveRecord::Base
  METHOD_TYPE = [ :credit_card, :paypal, :bank_account ]
  validates :name, :type, :presence => true
  belongs_to :user




    state_machine :state, :initial => :unverified do

    event :to_verify do
      transition :unverified => :wait
    end

    event :verify do
      transition :wait => :verified
    end

    event :reject do
      transition :wait => :rejected
    end

    # state :rejected do
    #   validates :answer, :presence => true
    # end
    after_transition :to => :wait, :do => :send_to_verify

  end

  state_machines[:state].states.map{|v| scope v.name, where(:state => v.value ) }

  def send_to_verify
    UserMailer.payment_method_to_admin(self).deliver
  end

  def method_type
    type.to_s.underscore.split('/').last.to_sym
  end


  class << self
    def detect(owner, method_id)
      if (obj = owner.seller_payment_methods.find(method_id))
        (case obj.method_type
         when :credit_card  then SellerPaymentMethod::CreditCard
         when :paypal       then SellerPaymentMethod::Paypal
         when :bank_account then SellerPaymentMethod::BankAccount
         end).find(method_id)
      else
        nil
      end
    end

    def build(params)
      case params[:type].to_sym
      when :credit_card
        SellerPaymentMethod::CreditCard.create(params)
      when :paypal
        SellerPaymentMethod::Paypal.create(params)
      when :bank_account
        SellerPaymentMethod::BankAccount.create(params)
      else
        create(params)
      end
    end
  end
end
