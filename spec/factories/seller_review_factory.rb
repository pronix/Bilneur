Factory.define :seller_review do |t|
  t.association(:seller, :factory => :user)
  t.association(:buyer, :factory => :user)
  t.association(:order, :factory => :order)
  t.review { Faker::Lorem.paragraphs(rand(5)+1) }
  t.rating { rand(5) }
end
