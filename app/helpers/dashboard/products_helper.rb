module Dashboard::ProductsHelper
  def select_by_param(param_name, field)
    return 'selected="selected"' if params[param_name] == field
  end
end
