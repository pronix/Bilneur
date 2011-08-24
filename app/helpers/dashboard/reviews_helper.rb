module Dashboard::ReviewsHelper

  # Return a link to approved review
  def link_approved(review)
    review.approved rescue ''
    link_to('Approve', approve_dashboard_review_path(review), :class => 'itmN', :remote => true, :onclick => "$(this).remove();") if !review.approved
  end

  # def choose_template(params, ext_var)
  #   render_template = case params[:state]
  #                     when "product" then 'product'
  #                     when "as_seller" then 'as_seller'
  #                     when 'left' then 'left'
  #                     when 'as_buyer' then 'as_buyer'
  #                     else 'as_buyer'
  #   end
  #   render render_template, :locals => ext_var
  # end
end
