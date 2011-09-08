class Dashboard::PurchasesController < Dashboard::ApplicationController

  def index
    params[:search] ||= {}
    # If present select box, only for greated date!
    params[:search].merge!(params_2_hash(params[:select_by])) if params[:select_by].present?
    @search = current_user.orders.unscoped.complete.metasearch(params[:search])
    @orders = @search.paginate(paginate_options.merge({ :order => "created_at DESC" }))
  end

  private

  def params_2_hash(params)
    p_array = params.split('--')
    { p_array[0] => Time.now - p_array[1].to_i.days }
  end

end
