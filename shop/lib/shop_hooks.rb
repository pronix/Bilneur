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

  insert_after :admin_variant_new_form do
    %(
       <p>
         <%= f.label :condition, t("condition") %>:<br />
         <%= select_tag("variant[condition]", options_for_select([ ['new','new'], ['used','used'] ] )) %>
      </p>


      )
  end

end
