Bilneur::Application.routes.draw do
  root :to => "home#index"

  match "/account" => "dashboard/users#show"

  # User dashboard
  #
  namespace :dashboard do
    root :to => "users#show"
    resources :quotes
    resource :account, :controller => "users"
  end

end
