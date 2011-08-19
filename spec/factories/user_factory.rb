unless Factory.factories.keys.include?(:user)
  Factory.define(:user) do |f|
    f.email { Faker::Internet.email }
    f.password "spree123"
    f.password_confirmation "spree123"
    f.firstname { Faker::Name.first_name }
    f.lastname { Faker::Name.last_name }
    f.reviews_count 0
    f.avg_rating { BigDecimal.new("0.0") }
  end
end

Factory.define(:admin_user, :parent => :user) do |u|
  u.roles { [Role.find_by_name("admin") || Factory(:role, :name => "admin")]}
end

Factory.sequence :login do |n|
  Faker::Internet.user_name + n.to_s
end
