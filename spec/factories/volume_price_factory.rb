Factory.define :volume_price do |f|
  f.association(:variant, :factory => :variant)
  f.range "(4+)"
  f.amount { BigDecimal.new("#{rand(200)}.#{rand(99)}") }
end
