Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'create_csv', to: 'pages#create_csv'
  resources :clothing do
    resources :tags
    resources :colors
    post 'toggle_active', to: 'clothing#toggle_active'
  end

  root to: 'clothing#index'
end
