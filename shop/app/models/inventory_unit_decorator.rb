InventoryUnit.state_machines[:state] = StateMachine::Machine.new(InventoryUnit, :initial => 'on_hand') do
  event :fill_backorder do
    transition :to => 'sold', :from => 'backordered'
  end
  event :ship do
    transition :to => 'shipped', :if => :allow_ship?
  end
  event :return do
    transition :to => 'returned', :from => 'shipped'
  end

  after_transition :on => :fill_backorder, :do => :update_order
  after_transition :to => 'returned', :do => :restock_variant
  after_transition :to => 'shipped', :do => :move_to_virtual_buyer
end

InventoryUnit.class_eval do

  # Moved virtual purchases to buyer or stay on seller
  #
  def move_to_virtual_buyer
    quantity = order.line_items.find_by_variant_id(variant_id).quantity
    if order.shipment.shipping_method.to_bilneur?
      variant.move_to_virtual_seller(order.user, quantity )
    elsif order.shipment.shipping_method.with_seller?
      SellerStore.create!(:seller   => variant.seller,  :dealer   => order.user,  :variant  => variant,
                         :quote    => variant.move_to_virtual_seller(order.user, quantity ),
                         :order    => order, :quantity => quantity        )
    end

  end

  class << self


    # manages both variant.count_on_hand and inventory unit creation
    #
    def increase(order, variant, quantity)
      back_order = determine_backorder(order, variant, quantity)
      sold = quantity - back_order

      #set on_hand if configured
      if Spree::Config[:track_inventory_levels]
        variant.decrement!(:count_on_hand, quantity)
      end

      #create units if configured
      if Spree::Config[:create_inventory_units]
        create_units(order, variant, sold, back_order)
      end
    end




    def create_units(order, variant, sold, back_order)
      if back_order > 0 && !Spree::Config[:allow_backorders]
        raise "Cannot request back orders when backordering is disabled"
      end

      shipment = order.shipments.detect {|shipment| !shipment.shipped? && (shipment.seller == variant.seller) }

      sold.times {
        order.inventory_units.create(:variant => variant, :state => "sold", :shipment => shipment)
      }
      back_order.times {
        order.inventory_units.create(:variant => variant, :state => "backordered", :shipment => shipment)
      }
    end



  end # end class << self


end
