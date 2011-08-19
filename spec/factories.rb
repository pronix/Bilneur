Zone.class_eval do
  def self.global
    find_by_name("GlobalZone") || Factory(:global_zone)
  end
end

require 'factory_girl'

Dir["#{File.dirname(__FILE__)}/factories/**"].each do |f|
  fp =  File.expand_path(f)
  require fp
end

Factory.define :message do |t|
  t.subject "Question-1"
  t.content "Question-1 content"
  t.association(:sender, :factory => :user)
  t.association(:recipient, :factory => :user)
end

Factory.define :seller_payment_method do |t|
  t.type "SellerPaymentMethod::CreditCard"
  t.name "My Visa"
  t.state "unverified"
end

Factory.define :secret_question do |t|
  t.user { |p| p.accociation(:user) }
  t.variant { |p| p.association(:secret_question_variant)}
  t.answer { Faker::Lorem.words.join(' ') }
end

Factory.define :secret_question_variant do |t|
  t.variant { Faker::Lorem.sentences(1) }
  t.private false
end
