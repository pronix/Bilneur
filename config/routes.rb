Bilneur::Application.routes.draw do
  get "products/index"

  get "products/new"

  get "products/edit"

  # routes moved to ./shop/config/routes.rb
end
