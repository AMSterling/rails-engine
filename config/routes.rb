Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get 'items/find_all', to: 'items/search#index'
      get 'items/find', to: 'items/search#show'
      get 'merchants/find_all', to: 'merchants/search#index'
      get 'merchants/find', to: 'merchants/search#show'
      get 'merchants/most_items', to: 'merchants/report#index'

      resources :merchants, only: %i[index show] do
        get '/items', to: 'merchant_items#index'
      end
      resources :items, only: %i[index show create update destroy] do
        get '/merchant', to: 'item_merchant#show'
      end
      namespace :revenue do
        resources :merchants, only: %i[index show]
      end
    end
  end
end
