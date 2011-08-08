Rails.application.routes.draw do
  # Add your extension routes here

  match "/top/:kind" => "home#top", :as => :top, :defaults => { :kind => 'products' },
                     :constraints => { :kind => /products|sellers|deals/ }


  match "/account" => "dashboard/users#show"
  match "/products/deals/:id(/:condition)" => "products#quotes", :as => :product_quotes
  match "/products/deals/:id/:quote_id" => "products#quote", :as => :product_quote

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
      resource :return_policies, :only => [:show, :edit, :update]
    end

    resources :orders, :only => [:index, :show]
    resources :sales,  :only => [:index, :show]
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

    resource :account, :controller => "users", :only => [:show, :edit, :update]
    resources :shipping_methods
    resource :terms
  end

end
