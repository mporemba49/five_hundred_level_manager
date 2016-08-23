Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/create_csv', to: 'pages#create_csv'
  get '/login', to: 'sessions#login'
  get '/logout', to: 'sessions#logout'
  post '/confirm_login', to: 'sessions#confirm_login'

  resources :sales_channels
  resources :colors
  resources :sizes
  resources :royalties
  resources :reserved_designs
  resources :team_player_designs

  resources :clothing do
    get '/clothing_colors', to: 'clothing_colors#edit'
    put '/clothing_colors', to: 'clothing_colors#update'
    post 'toggle_active', to: 'clothing#toggle_active'
    resources :tags
  end

  root to: 'sessions#login'
end
