Bilneur::Application.routes.draw do
  match "/account" => "dashboard/users#show"

  # User dashboard
  #
  namespace :dashboard do
    root :to => "users#show"
    resources :quotes
    resource :account, :controller => "users"
  end

end
