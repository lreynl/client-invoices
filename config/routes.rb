Rails.application.routes.draw do
  resources :clients, param: :name do
    resources :invoices
  end

  resources :clients do 
    get 'summary', on: :member
  end

  match '*path', to: 'application#render_404', via: :all
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
