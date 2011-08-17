# -*- encoding : utf-8 -*-
require 'print_invoice_hooks'
require 'prawn_handler'


module PrintInvoice
  class Engine < Rails::Engine
    
    def self.activate

      Admin::OrdersController.class_eval do
        respond_to :html, :pdf
        respond_override(:show => {:pdf => {:success =>
            lambda { render :layout => false, :template => "admin/orders/#{params[:template] || "invoice"}.pdf.prawn" } } })
      end

    end

    config.autoload_paths += %W(#{config.root}/lib)
    config.to_prepare &method(:activate).to_proc

  end
end

Mime::Type.register 'application/pdf', :pdf
