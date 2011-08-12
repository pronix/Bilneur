class Dashboard::ReturnPoliciesController < Dashboard::ApplicationController

  before_filter :load_data

  def show

  end

  def edit
  end

  def update
    if @quote.update_attributes(params[:variant])
      redirect_to dashboard_quote_return_policies_path(@quote), :notice => "Return Policy updated."
    else
      render :edit
    end
  end

  private

  def load_data
    @quote = current_user.quotes.find(params[:quote_id])
  end

end
