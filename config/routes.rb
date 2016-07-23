Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :clothing do
    resources :tags
    resources :colors
  end
end
