Rails.application.routes.draw do
  resources :clients, param: :name do
    resources :invoices
  end

  resources :clients do 
    get 'summary', on: :member
  end

  root to: 'home#render_401'

  match '*path', to: 'application#render_404', via: :all
end
