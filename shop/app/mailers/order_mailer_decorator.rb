OrderMailer.class_eval do

  def confirm_email_to_seller(order, seller, resend=false)
    @order = order
    @seller = seller
    subject = (resend ? "[RESEND] " : "")
    subject += "#{Spree::Config[:site_name]} #{t('subject', :scope =>'order_mailer.confirm_email')} ##{order.number}"
    mail(:to => @seller.email, :subject => subject)
  end
end

