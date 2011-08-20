module SpreeSite
  class Engine < Rails::Engine
    def self.activate
      Ability.register_ability(SellerAbility)
      AppConfiguration.class_eval do
        preference :support_email,            :string,  :default => "support@berlin.com"
        preference :site_url,                 :string,  :default => "bilneur.adenin.ru"
        preference :allow_guest_checkout,     :boolean, :default => false
        preference :allow_ssl_in_production,  :boolean, :default => false
        preference :print_invoice_logo_path,  :string,  :default => "public/images/admin/bg/spree_50.png"

        preference :facebook_app_id, :string
        preference :facebook_admins, :string, :default => "1509902962"

      end if ::Product.table_exists?

      ActionMailer::Base.class_eval do
        default_url_options[:host] = Spree::Config[:site_url]
        default :from => (MailMethod.current.try(:preferred_mails_from) || "no-reply@bilneur.adenin.ru" )
      end if ::Product.table_exists?



    end

    def load_tasks
    end

    config.to_prepare &method(:activate).to_proc
  end
end
