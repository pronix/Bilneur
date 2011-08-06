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
    elsif params[:controller] == "products" && params[:action] == "show"
      c_class = "prdctDPg" 
    elsif params[:controller] == "products" && params[:action] == "index"
      c_class = "prdctDPg slrPrdctPg prdctPg" 
    end
    c_class
  end
end
