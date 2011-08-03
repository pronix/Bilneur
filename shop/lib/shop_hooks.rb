class ShopHooks < Spree::ThemeSupport::HookListener
  # custom hooks go here
  insert_after :admin_product_form_right do
    %(
      <p>
        <%= f.label :ean, t("ean") %><br />
        <%= f.text_field :ean, :size => 16 %>
      </p>
     )
  end


end
