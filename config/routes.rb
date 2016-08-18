Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/create_csv', to: 'pages#create_csv'
  get '/login', to: 'sessions#login'
  get '/logout', to: 'sessions#logout'
  post '/confirm_login', to: 'sessions#confirm_login'

  resources :colors
  resources :sizes
  resources :reserved_designs
  resources :team_players

  resources :clothing do
    resources :tags
    resources :colors
    post 'toggle_active', to: 'clothing#toggle_active'
  end

  root to: 'sessions#login'
end
