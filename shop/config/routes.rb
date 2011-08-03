Rails.application.routes.draw do
  # Add your extension routes here

  match "/account" => "dashboard/users#show"

  # User dashboard
  #
  namespace :dashboard do
    root :to => "users#show"

    resources :quotes, :path_names => { :new => "(/:product_ean)/new"} do
      collection do
        match "/search" => "quotes#search", :as => :search, :via => [:get, :post]
      end

      member  do
        get :options
      end

      resources :quote_images do
        collection do
          post :update_positions
        end
      end

      resource :selling_options

    end



    resources :properties
    resources :option_types do
      collection do
        post :update_positions
      end
    end



    resources :products do


      resources :images do
        collection do
          post :update_positions
        end
      end

      resources :product_properties


      resources :option_types do
        member do
          get :select
          get :remove
        end
        collection do
          get :available
          get :selected
        end
      end

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
