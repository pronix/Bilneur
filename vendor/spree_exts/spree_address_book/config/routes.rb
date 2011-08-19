Rails.application.routes.draw do
  resources :addresses, :only => [:edit, :update, :destroy] do

    member do
      get :info
    end

    collection do
      match "make/:state/:order_id" => "addresses#make", :as => :make, :via => :post
    end

  end
end
