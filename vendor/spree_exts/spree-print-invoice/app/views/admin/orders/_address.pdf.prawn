# Address Stuff

bill_address = @order.bill_address
ship_address = @order.ship_address
shipping_method = @order.shipping_method
anonymous = @order.email =~ /@example.net$/


bounding_box [0,600], :width => 540 do
  move_down 2
  data = [[Prawn::Table::Cell.new( :text => I18n.t(:billing_address), :font_style => :bold ),
                Prawn::Table::Cell.new( :text =>I18n.t(:shipping_address), :font_style => :bold )]]
                
  if anonymous and Spree::Config[:suppress_anonymous_address]
    data << [[" ", " "]] * 6
  else
    data << ["#{bill_address.firstname} #{bill_address.lastname}", 
              "#{ship_address.firstname} #{ship_address.lastname}"]
    data << [bill_address.address1.strip, ship_address.address1.strip]
    data << [bill_address.address2.strip, ship_address.address2.strip] unless 
              bill_address.address2.blank? and ship_address.address2.blank?
    data << ["#{@order.bill_address.city} #{@order.bill_address.state_text} #{@order.bill_address.zipcode}",
                "#{@order.ship_address.city} #{@order.ship_address.state_text} #{@order.ship_address.zipcode}"]
    data << [bill_address.country.name.strip, ship_address.country.name.strip]
    data << [bill_address.phone.strip, ship_address.phone.strip]
    data << [" ", "Shipping method: #{shipping_method.name}"] if shipping_method
  end

  table data,
    :position           => :center,
    :border_width => 0.5,
    :vertical_padding   => 2,
    :horizontal_padding => 6,
    :font_size => 12,
    :border_style => :underline_header,
    :column_widths => { 0 => 270, 1 => 270 }

  move_down 2

  stroke do
    line_width 0.5
    line bounds.top_left, bounds.top_right
    line bounds.top_left, bounds.bottom_left
    line bounds.top_right, bounds.bottom_right
    line bounds.bottom_left, bounds.bottom_right
  end

end
