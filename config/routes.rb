Rails.application.routes.draw do
  resources :brands
  resources :locations

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/create_csv', to: 'pages#create_csv'
  post '/kill_jobs', to: 'pages#kill_jobs'
  post '/sku_csv', to: 'pages#sku_csv'
  post '/check_sku', to: 'inventory_items#check_sku'
  get  'pages/index', to: 'pages#index'
  get '/login', to: 'sessions#login'
  get '/logout', to: 'sessions#logout'
  post '/confirm_login', to: 'sessions#confirm_login'
  post 'inventory_items/mass_action', to: 'inventory_items#mass_action'
  get 'inventory_items/destroy_all', :to => 'inventory_items#destroy_all'
  get 'inventory_items/soft_deleted', to: 'inventory_items#soft_deleted'
  post 'inventory_items/recover/:id', to: 'inventory_items#recover'
  post 'team_player_designs/mass_delete', to: 'team_player_designs#mass_delete'
  post 'team_players/mass_delete', to: 'team_players#mass_delete'
  post 'clothing/mass_toggle', to: 'clothing#mass_toggle'
  post 'accessory/mass_toggle', to: 'accessory#mass_toggle'

  resources :sales_channels
  resources :colors
  resources :teams do
    resources :team_players, only: :index
  end
  resources :team_players, only: [:show, :edit, :update, :destroy]
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
