module ProductHelper
  # Show stars of rating product
  # yel_str = Rating start
  # grey_str = Non rating star
  def show_stars(product, yel_str='icons/yel_str.png',grey_str='icons/grey_str.png',html_wrapper="<i>")
    wrapper = html_wrapper + 'PASTE_HERE' + html_wrapper.gsub(/^</, '</')
    yel_star = wrapper.gsub('PASTE_HERE', "#{image_tag yel_str}")
    grey_star = wrapper.gsub('PASTE_HERE', "#{image_tag grey_str}")
    # First we want know ratting of product with yellow.
    out = yel_star * product.avg_rating.to_i
    out += grey_star * (5 - product.avg_rating.to_i)
    return out.html_safe
  end
end
