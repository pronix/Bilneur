Factory.define :review do |t|
  t.association(:product, :factory => :product)
  t.name 'FAKE'
  t.location "here"
  t.rating { rand(5) }
  t.review { Faker::Lorem.paragraphs(1) }
  t.approved false
  t.association(:user, :factory => :user)
  t.ip_address "#{rand(255)}.#{rand(255)}.#{rand(255)}.#{rand(255)}"
  t.created_at { Time.now - 1.hour }
end
