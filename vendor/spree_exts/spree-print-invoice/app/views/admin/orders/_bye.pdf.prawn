font_name = Spree::Config[:print_invoice_font_name] || "Helvetica"

font font_name, :size => 8, :color => "#444444"
move_down 10 

text I18n.t(:note)

move_down 20 

hook :extra_note do 
end


