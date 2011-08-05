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
      "prdctDPg"
    else
      ""
    end
  end

end
