Rails.application.routes.draw do
  # Add your extension routes here
  match "/account" => "dashboard/users#show"

  # User dashboard
  #
  namespace :dashboard do
    root :to => "users#show"

    resources :quotes, :path_names => { :new => "/:product_permalink/new" } do
      collection do
        match "/search" => "quotes#search", :as => :search, :via => [:get, :post]
      end
    end

    resources :properties

    resources :products do
      resources :images
    end

    resource :account, :controller => "users"
  end

end
