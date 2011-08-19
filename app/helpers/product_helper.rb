module ProductHelper
  # Show stars of rating product
  # yel_str = Rating start
  # grey_str = Non rating star
  def show_stars(rating, yel_str='icons/yel_str.png',grey_str='icons/grey_str.png',html_wrapper="<i>")
    html_wrapper_end = html_wrapper.gsub(/^</, '</')
    # Define yellow and grey star image link
    yel_star = html_wrapper + image_tag(yel_str) + html_wrapper_end
    grey_star = html_wrapper + image_tag(grey_str) + html_wrapper_end
    # First we want know ratting of product with yellow.
    out = yel_star * rating.to_i
    out += grey_star * (5 - rating.to_i)
    return out.html_safe
  end

  def show_user_photo(user)
    return image_tag '/images/missing/photo/missing_medium_for_review.png' if user.nil?
    image_tag user.photo.url(:for_review)
  end

  # Check if user early create review by this product
  def can_create_review?(product)
    return true if @current_user.nil?
    true if product.reviews.where(:user_id => @current_user.id).blank?
  end

  def product_link_image(product, size)
    return '/images/noimage/small.jpg' if product.images.blank?
    product.images.first.attachment.url(size)
  end

end
