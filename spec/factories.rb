# Factory.define :user do |u|
#   u.login { Faker::Internet.user_name + Faker::Internet.user_name }
#   u.email { Faker::Internet.email }
#   u.password "123456"
#   u.password_confirmation { |x| x.password }
# end

# Factory.define :review do |r|
#   # r.product_id 1
#   # r.name 'My name is fido'
#   # r.rating 3
#   # r.title 'This is title'
#   # r.review 'This is review'
#   # r.ip_address '127.0.0.1'
# end
