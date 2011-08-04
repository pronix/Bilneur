module ApplicationHelper
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  def content_class
    c_class = ""
    if params[:controller] == "home" 
      c_class = "cHome" 
    elsif params[:controller] == "products"
      c_class = "prdctDPg" 
    end
    c_class
  end
end
