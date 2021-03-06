# Variant constants
#
Variant::CONDITION = %w(new used another) unless Variant.const_defined?("CONDITION")
Variant::CONDITION_MAP = { :new => 1, :used => 2, :another => 3} unless Variant.const_defined?("CONDITION_MAP")


Variant::WAREHOUSE_MERCHANT = "merchant" unless Variant.const_defined?("WAREHOUSE_MERCHANT")
Variant::WAREHOUSE_BILNEUR  = "bilneur"  unless Variant.const_defined?("WAREHOUSE_BILNEUR")
Variant::WAREHOUSE_SELLER   = "seller"   unless Variant.const_defined?("WAREHOUSE_SELLER")
Variant::WAREHOUSE = [ Variant::WAREHOUSE_MERCHANT,
                       Variant::WAREHOUSE_BILNEUR,
                       Variant::WAREHOUSE_SELLER  ] unless Variant.const_defined?("WAREHOUSE")

# Shipping method contsants
#
ShippingMethod::METHOD_KIND_TO_ADDRESS  = "to_address"  unless ShippingMethod.const_defined?("METHOD_KIND_TO_ADDRESS" )
ShippingMethod::METHOD_KIND_TO_BILNEUR  = "to_bilneur"  unless ShippingMethod.const_defined?("METHOD_KIND_TO_BILNEUR")
ShippingMethod::METHOD_KIND_WITH_SELLER = "with_seller" unless ShippingMethod.const_defined?("METHOD_KIND_WITH_SELLER")

