Rails.application.routes.draw do
  # resources :posts
  # resources :users
  resources :users, param: :name do
    resources :posts
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
