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
    if bill_address
      data << ["#{bill_address.try(:firstname)} #{bill_address.try(:lastname)}",
              "#{ship_address.try(:firstname)} #{ship_address.try(:lastname)}"]

      data << [bill_address.try(:address1).to_s.strip, ship_address.try(:address1).to_s.strip]
      data << [bill_address.try(:address2).to_s.strip, ship_address.try(:address2).to_s.strip] unless
              bill_address.try(:address2).blank? and ship_address.try(:address2).blank?

      data << ["#{@order.bill_address.try(:city)} #{@order.bill_address.try(:state_text)} #{@order.bill_address.try(:zipcode)}",
                "#{@order.ship_address.try(:city)} #{@order.ship_address.try(:state_text)} #{@order.ship_address.try(:zipcode)}"]
      data << [bill_address.country.try(:name).to_s.strip, ship_address.try(:country).try(:name).to_s.strip]
      data << [bill_address.phone.to_s.strip, ship_address.try(:phone).to_s.strip]
    end

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
