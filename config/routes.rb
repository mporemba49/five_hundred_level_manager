Rails.application.routes.draw do
  resources :locations
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/create_csv', to: 'pages#create_csv'
  post '/kill_jobs', to: 'pages#kill_jobs'
  post '/sku_csv', to: 'pages#sku_csv'
  post '/check_sku', to: 'inventory_items#check_sku'
  get  'pages/index', to: 'pages#index'
  get '/login', to: 'sessions#login'
  get '/logout', to: 'sessions#logout'
  post '/confirm_login', to: 'sessions#confirm_login'
  post 'inventory_items/mass_delete', to: 'inventory_items#mass_delete'
  get 'inventory_items/soft_deleted', to: 'inventory_items#soft_deleted'
  post 'inventory_items/recover/:id', to: 'inventory_items#recover'
  post 'team_player_designs/mass_delete', to: 'team_player_designs#mass_delete'

  resources :sales_channels
  resources :colors
  resources :teams
  resources :sizes
  resources :royalties
  resources :reserved_designs
  resources :team_player_designs
  resources :inventory_items do
    member do
      post 'recover'
    end
  end

  resources :clothing do
    get '/clothing_colors', to: 'clothing_colors#edit'
    put '/clothing_colors', to: 'clothing_colors#update'
    get '/clothing_sizes', to: 'clothing_sizes#edit'
    put '/clothing_sizes', to: 'clothing_sizes#update'
    post 'toggle_active', to: 'clothing#toggle_active'
    resources :tags
  end

  resources :accessory do
    get '/accessory_colors', to: 'accessory_colors#edit'
    put '/accessory_colors', to: 'accessory_colors#update'
    get '/accessory_sizes', to: 'accessory_sizes#edit'
    put '/accessory_sizes', to: 'accessory_sizes#update'
    post 'toggle_active', to: 'accessory#toggle_active'
    resources :tags
  end

  root to: 'sessions#login'
end
