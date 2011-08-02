Rails.application.routes.draw do
  # Add your extension routes here
  match "/account" => "dashboard/users#show"

  # User dashboard
  #
  namespace :dashboard do
    root :to => "users#show"

    resources :quotes, :path_names => { :new => "/:product_ean/new"} do
      collection do
        match "/search" => "quotes#search", :as => :search, :via => [:get, :post]
      end
    end

    resources :properties

    resources :products do


      resources :images do
        collection do
          post :update_positions
        end
      end

      resources :product_properties


      resources :taxons do
        member do
          get :select
          delete :remove
        end
        collection do
          post :available
          post :batch_select
          get  :selected
        end
      end

    end

    resource :account, :controller => "users"
  end

end
