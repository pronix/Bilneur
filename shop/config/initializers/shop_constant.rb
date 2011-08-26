# Variant constants
#
Variant::CONDITION = %w(new used another) unless Variant.const_defined?("CONDITION")
Variant::CONDITION_MAP = { :new => 1, :used => 2, :another => 3} unless Variant.const_defined?("CONDITION_MAP")

# Shipping method contsants
#
ShippingMethod::METHOD_KIND_TO_ADDRESS  = "to_address"  unless ShippingMethod.const_defined?("METHOD_KIND_TO_ADDRESS" )
ShippingMethod::METHOD_KIND_TO_BILNEUR  = "to_bilneur"  unless ShippingMethod.const_defined?("METHOD_KIND_TO_BILNEUR")
ShippingMethod::METHOD_KIND_WITH_SELLER = "with_seller" unless ShippingMethod.const_defined?("METHOD_KIND_WITH_SELLER")

