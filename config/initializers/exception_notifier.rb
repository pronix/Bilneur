require "exception_notifier"
Bilneur::Application.config.middleware.use ExceptionNotifier,
  :email_prefix => "[ Bilneur ]",
  :sender_address => %{ "bilneur" <notify@bilneur.com> },
  :exception_recipients => %w{ parallel588@gmail.com ezotrank@gmail.com  }
