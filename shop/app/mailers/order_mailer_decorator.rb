OrderMailer.class_eval do

  def confirm_email_to_seller(order, resend=false)
    @order = order
    subject = (resend ? "[RESEND] " : "")
    subject += "#{Spree::Config[:site_name]} #{t('subject', :scope =>'order_mailer.confirm_email')} ##{order.number}"
    mail(:to => order.line_items.first.variant.seller.email,
         :subject => subject)
  end
end

