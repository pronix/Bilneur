Factory.define :user do |u|
  u.login { Faker::Internet.user_name + Faker::Internet.user_name }
  u.email { Faker::Internet.email }
  u.password "123456"
  u.password_confirmation { |x| x.password }
end
