class Dashboard::SellingOptionsController <  Dashboard::ApplicationController

  helper Admin::BaseHelper
  helper Admin::NavigationHelper
  before_filter :load_data

  def show

  end

  def update
    if @quote.update_attributes(params[:variant])
      flash.notice = "Options updated."
    end
    redirect_to dashboard_quote_selling_options_path(@quote)
  end

  private

  def load_data
    @quote = current_user.quotes.find(params[:quote_id])
  end
end
