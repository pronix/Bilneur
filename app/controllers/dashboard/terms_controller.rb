class Dashboard::TermsController < Dashboard::ApplicationController

  def edit

  end

  def update
    if current_user.update_attribute(:terms, params[:user][:terms])
      flash.notice = "Terms & Conditions updated."
    end
    redirect_to edit_dashboard_terms_path
  end

end
