module ProductHelper
  # Show stars of rating product
  # yel_str = Rating start
  # grey_str = Non rating star
  def show_stars(product, yel_str='icons/yel_str.png',grey_str='icons/grey_str.png',html_wrapper="<i>")
    html_wrapper_end = html_wrapper.gsub(/^</, '</')
    # Define yellow and grey star image link
    yel_star = html_wrapper + image_tag(yel_str) + html_wrapper_end
    grey_star = html_wrapper + image_tag(grey_str) + html_wrapper_end
    # First we want know ratting of product with yellow.
    out = yel_star * product.avg_rating.to_i
    out += grey_star * (5 - product.avg_rating.to_i)
    return out.html_safe
  end
end
