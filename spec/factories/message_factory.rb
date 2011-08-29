Factory.define :message do |f|
  f.association(:sender, :factory => :user)
  f.association(:recipient, :factory => :user)
  f.subject { Faker::Lorem.sentence }
  f.content { Faker::Lorem.paragraphs(1).to_s }
end
