module ProductHelper
  # Show stars of rating product
  def show_stars(product, yel_str='icons/yel_str.png',grey_str='icons/grey_str.png')
    yel_star = "<i>#{image_tag yel_str}</i>"
    grey_star = "<i>#{image_tag grey_str}</i>"
    # First we want know ratting of product with yellow.
    out = yel_star * product.avg_rating.to_i
    out += grey_star * (5 - product.avg_rating.to_i)
    return out.html_safe
  end
end
