UserMailer.class_eval do
  def payment_method_to_admin(payment_method)
    default_url_options[:host] = Spree::Config[:site_url]
    @payment_method = payment_method
    mail(:to => Spree::Config[:support_email],
         :subject => Spree::Config[:site_name] + ' ' + I18n.t("mailer.new_payment_method"))

  end
end
