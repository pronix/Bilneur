Factory.define(:variant) do |f|
  f.price { BigDecimal.new("#{rand(200)}.#{rand(99)}") }
  f.cost_price { |u| u.price - 5}
  f.count_on_hand 10
  f.condition "used"
  f.sku    { Faker::Lorem.sentence }
  f.weight { BigDecimal.new("#{rand(200)}.#{rand(99)}") }
  f.height { BigDecimal.new("#{rand(200)}.#{rand(99)}") }
  f.width  { BigDecimal.new("#{rand(200)}.#{rand(99)}") }
  f.depth  { BigDecimal.new("#{rand(200)}.#{rand(99)}") }
  f.active true
  # associations:
  f.option_values { [Factory(:option_value)] }
  f.association(:owner, :factory => :user)
  f.association(:seller, :factory => :user)
  f.association(:product, :factory => :product)
end

