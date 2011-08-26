# Variant constants
#
Variant::CONDITION = %w(new used another)
Variant::CONDITION_MAP = { :new => 1, :used => 2, :another => 3}

# Shipping method contsants
#
ShippingMethod::METHOD_KIND_TO_ADDRESS  = "to_address"    # simple method
ShippingMethod::METHOD_KIND_TO_BILNEUR  = "to_bilneur"    # shipped to bilneur warehouse
ShippingMethod::METHOD_KIND_WITH_SELLER = "with_seller"   # no shipped, store the product

