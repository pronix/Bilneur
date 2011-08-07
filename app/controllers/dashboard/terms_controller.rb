class Dashboard::TermsController < Dashboard::ApplicationController

  helper Admin::BaseHelper
  helper Admin::NavigationHelper

  def edit

  end

  def update
    if current_user.update_attribute(:terms, params[:user][:terms])
      flash.notice = "Terms & Conditions updated."
    end
    redirect_to edit_dashboard_terms_path
  end

end
