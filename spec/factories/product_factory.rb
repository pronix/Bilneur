Factory.sequence(:product_sequence) {|n| "Product ##{n} - #{rand(9999)}"}

Factory.define :product do |f|
  f.name { Factory.next(:product_sequence) }
  f.description { Faker::Lorem.paragraphs(rand(5)+1).join("\n") }

  # associations:
  f.association(:owner, :factory => :user)
  f.tax_category {|r| TaxCategory.find(:first) || r.association(:tax_category)}
  f.shipping_category {|r| ShippingCategory.find(:first) || r.association(:shipping_category)}

  f.price 19.99
  f.cost_price 17.00
  f.sku "ABC"
  f.available_on { 1.year.ago }
  f.deleted_at nil
  f.ean { Factory.next(:product_sequence) }
end

Factory.define(:product_with_variant, :parent => :product) do |u|
  u.after_create do |product|
    # Factory(:variant, :product => product, :is_master => true, :seller => product.owner)
    product.variants << Factory.build(:variant, :product => product, :seller => product.owner, :owner => product.owner)
  end
end
