Factory.sequence(:shipping_calculable_sequence) {|n| n }

Factory.define :shipping_method do |f|
  f.zone {|a| Zone.find_by_name("GlobalZone") || a.association(:global_zone) }
  f.name 'UPS Ground'
  f.calculator { |sm|
    Factory(:calculator,
            :calculable_id => Factory.next( :shipping_calculable_sequence ),
            :calculable_type => "ShippingMethod") }
  f.association(:seller, :factory => :user)
end

Factory.define :free_shipping_method, :class => ShippingMethod do |f|
  f.zone {|a| Zone.find_by_name("GlobalZone") || a.association(:global_zone) }
  f.name 'UPS Ground'
  f.calculator { |sm| Factory(:no_amount_calculator, :calculable_id => sm.object_id, :calculable_type => "ShippingMethod") }
  f.association(:seller, :factory => :user)
end
