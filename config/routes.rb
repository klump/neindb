require 'api_constraints'

Rails.application.routes.draw do
  devise_for :users, path: 'auth'

  resources :users
  resources :assets
  resources :revisions, only: [:show, :index]
  resources :statuses, only: [:show, :index]
  resources :components
  resources :reports, only: [:show, :index]

  namespace :api, defaults: { format: :json } do
    apipie
    scope module: :v1, constraints: ApiConstraints.new( version: 1, default: true ) do
      root 'base#index'
      resources :users, only: [:show]
      resources :assets, only: [:index, :show, :create, :update, :destroy] do
        get 'search', on: :collection
      end
      resources :revisions, only: [:index, :show, :create, :update, :destroy]
      resources :statuses, only: [:index, :show, :create, :update, :destroy]
      resources :components, only: [:index, :show, :create, :update, :destroy]
      resources :reports, only: [:index, :show, :create, :update]
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'dashboards#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
