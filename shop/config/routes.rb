Rails.application.routes.draw do
  # Add your extension routes here

  match "/top/:kind" => "home#top", :as => :top, :defaults => { :kind => 'products' },
                                                 :constraints => { :kind => /products|sellers|deals/ }

  match "/account" => "dashboard/users#show"
  match "/account/change_password" => "dashboard/users#change_password", :via => [:get, :put]
  match "/dashboard/upload_photo" => "dashboard/users#upload_photo", :via => [:get, :put]
  match "/products/deals/:id(/:condition)" => "products#quotes", :as => :product_quotes
  match "/products/group_sale/:id(/:condition)" => "products#group_sale", :as => :product_group_sale
  match "/products/deals/:id/:quote_id" => "products#quote", :as => :product_quote
  match "/products/like_review" => 'products#like_review', :via => :post
  match "/messages/:user_id/new" => "dashboard/messages#new", :as => :new_message

  # match "/sellers/:seller_id/store" => "products#all_sellers_product"

  match "/sellers/:id/store/:product_id/:quote_id" => "sellers#quote", :as => :seller_quote
  resources :sellers, :only => [ ] do
    member do
      get :store
      get :about
      get :customer_service
      get :feedback
      get :return_policy
    end
  end

  # Product
  resources :products do
    # In spree-review has routes /review But we don't want to use this route
    # We redirect this request to product page.
    match "/reviews" => redirect("/products/%{product_id}"), :via => :get
  end

  match '/cart(/:cart_type)', :to => 'orders#update', :via => :put, :as => :update_virtual_cart
  match '/cart/empty(/:cart_type)', :to => 'orders#empty', :via => :put, :as => :empty_virtual_cart

  match '/checkout/registration' => 'checkout#registration', :via => :get, :as => :checkout_registration
  match '/checkout/registration' => 'checkout#update_registration', :via => :put, :as => :update_checkout_registration

  match '/checkout/(:order_type/)registration' => 'checkout#registration', :via => :get, :as => :virtual_checkout_registration
  match '/checkout/(:order_type/)registration' => 'checkout#update_registration', :via => :put, :as => :virtual_update_checkout_registration


  # non-restful checkout stuff
  match '/checkout/(:order_type/)update/:state' => 'checkout#update', :as => :virtual_update_checkout
  match '/checkout/(:order_type/):state' => 'checkout#edit', :as => :virtual_checkout_state
  match '/checkout/(:order_type)' => 'checkout#edit', :state => 'address', :as => :virtual_checkout

  # For recovery password by secret question
  match '/user/password/reset_by_question' => 'password_by_question#reset_by_question', :via => :post
  match '/user/password/new_password' => 'password_by_question#new_password', :via => :post

  # Favorite sellers
  resources :favorite_sellers, :controller => "favorite_sellers", :only => [] do
    member do
      get :add
    end
  end

  # Favorite variants
  resources :favorites, :controller => "favorite_products", :only => [ :destroy ] do
    member do
      get :add
      post :cart
    end
  end

  # User dashboard
  #
  namespace :dashboard do

    root :to => "users#show"

    resource :favorites, :only => [:destroy] do
      member do
        get :sellers
      end
    end

    resource :secrets
    resource :sellers do
      member do
        get :about_you
        put :about_you
        get :return_policy
        put :return_policy
      end
    end

    resources :reviews do
      member do
        get :approve
      end
      resources :feedback_reviews
    end

    resources :quotes, :path_names => { :new => "(/:product_ean)/new" } do
      match "(/:state)" => "quotes#index", :as => :state, :via => :get, :on => :collection,
                                                            :constraints => { :state => /merchant|bilneur|other/ }
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
      resources :group_sales, :only => [ :new, :create ]

    end # end dashboard < quotes

    resources :group_sales, :only => [:index, :show, :edit, :update, :destroy] do

      member do
        get :complete
        get :cancel
      end
    end

    resources :orders, :only => [:index, :show] do

      member do
        match "receive/:shipment_id" => "orders#receive" , :as => :receive, :via => [:get, :post]
      end
    end

    resources :virtual_orders, :only => [:index, :show]
    resources :sales,  :only => [:index, :show] do
      member do
        match "/track" => "sales#track", :as => :track, :via => [:get, :post]
        get :ship
      end

    end

    resources :virtual_sales,  :only => [:index, :show] do
      member do
        get :ship
      end
    end
    resources :seller_inventories, :only => [:index, :show]
    resources :purchases, :only => [:index, :show]

    resources :properties

    resources :option_types do
      collection do
        post :update_positions
      end
    end

    resources :products do

      collection do
        match "/wizard(/:state)(/:id)" => "products#wizard", :as => :wizard, :via => [ :post, :get, :put]

      end

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

      end # end dashboard < products < option_types

      resources :taxons do
        member do
          get :child
          get :select
          delete :remove
        end
        collection do
          post :available
          post :batch_select
          get  :selected
        end
      end # end dashboard < products < taxons

    end # end dashboard < products

    resource :account, :controller => "users", :only => [:show, :edit, :update]
    resources :shipping_methods
    resource :terms
    resources :addresses do
      member do
        get :make_primary
      end
    end
    resources :messages, :path => "inbox", :except => [:new, :edit, :update] do
      collection  do
        match "/:state" => "messages#index", :via => :get, :as => :state_inbox,
               :constraints => { :state => /received|sent|unread|important|trash/ }
        post :multi
      end
      member do
        post :reply
      end
    end

    resources :payment_methods do
      member do
        get :verify
      end
    end


  end # end dashboard



  # Admin
  #
  namespace :admin do

    resources :seller_payment_methods, :only => [:index, :show] do
      member do
        get :approve
        get :reject
      end
    end

  end # end admin

end
