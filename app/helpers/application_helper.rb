module ApplicationHelper

  # html without js
  #
  def raw_without_js(text = nil)
    raw(text.to_s.gsub(/<script>|<\/script>/, 'script').gsub('javascript', '_javascript_'))
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  def content_class
    case params[:controller].to_s
    when "home"
      "cHome"
    when "products"
      case params[:action].to_s
      when "index"
        "prdctDPg slrPrdctPg prdctPg"
      else
        "prdctDPg"
      end
    else
      ""
    end
  end


  def t122_image(product, *options)
    options = options.first || {}
    product_images = product.is_a?(Variant) ? [ product.images, product.product.images ].flatten : product.images
    if product_images.empty?
      image_tag "noimage/t122.jpg", options
    else
      image = product_images.first
      options.reverse_merge! :alt => image.alt.blank? ? product.name : image.alt
      image_tag image.attachment.url(:t122), options
    end
  end

  def filter_breadcrumbs(taxon, separator="&nbsp;&raquo;&nbsp;")
    return "" if current_page?("/")
    separator = raw(separator)
    # crumbs = [content_tag(:li, link_to(t(:home) , root_path) + separator)]
    crumbs = [content_tag(:li, "Filters")]
    if taxon
      crumbs << content_tag(:li, link_to(t('all_products') , products_path) + separator)
      crumbs << taxon.ancestors.collect { |ancestor| content_tag(:li, link_to(ancestor.name , seo_url(ancestor)) + separator) } unless taxon.ancestors.empty?
      crumbs << content_tag(:li,
                            content_tag(:li, link_to(taxon.name , seo_url(taxon))))
    else
      crumbs << content_tag(:li, content_tag(:b, t('all_products')))
    end
    content_tag(:ul, raw(crumbs.flatten.map{|li| li.mb_chars}.join))
  end

  def grand_order_price(order, order2, options={})
   options.assert_valid_keys(:format_as_currency, :show_vat_text, :show_price_inc_vat)
   options.reverse_merge! :format_as_currency => true, :show_vat_text => true

   # overwrite show_vat_text if show_price_inc_vat is false
   options[:show_vat_text] = Spree::Config[:show_price_inc_vat]

   amount = (order.try(:item_total)||0) + (order2.try(:item_total)||0)
   amount += Calculator::Vat.calculate_tax(order) if Spree::Config[:show_price_inc_vat]
   amount += Calculator::Vat.calculate_tax(order2) if Spree::Config[:show_price_inc_vat]

   options.delete(:format_as_currency) ? number_to_currency(amount) : amount
  end

end

