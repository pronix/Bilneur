module Dashboard::ReviewsHelper

  # Return a link to approved review
  def link_approved(review)
    review.approved rescue ''
    link_to('Approve', approve_dashboard_review_path(review), :class => 'itmN', :remote => true, :onclick => "$(this).remove();") if !review.approved
  end
end
