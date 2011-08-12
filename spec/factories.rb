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

Factory.define :review do |t|
  t.product { |p| p.association(:product) }
  t.name { Factory.next(:product_sequence) }
  t.location "here"
  t.rating "#{rand(5)}"
  t.review { Faker::Lorem.paragraphs(1) }
  t.approved false
  t.user_id { |p| p.association(:user) }
  t.ip_address "#{rand(255)}.#{rand(255)}.#{rand(255)}.#{rand(255)}"
end
