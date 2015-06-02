Rails.application.routes.draw do
  root 'welcome#index'
  get 'parser/cei' => 'parser#import'
  get 'parser' => 'parser#index'

  resources :enterprises, only: [:index, :show]

  get '/rankings' => 'rankings#index'
  get '/statistics' => 'statistics#index'
  get '/statistics/sanction_by_state_graph' => 'statistics#sanction_by_state_graph'
  get '/statistics/most_sanctioned_ranking' => 'statistics#most_sanctioned_ranking'
  get '/statistics/sanction_by_type_graph' => 'statistics#sanction_by_type_graph'
  get '/more' => 'welcome#more'
  get '/graphics' => 'graphics#index'
  get '*unmatched_route', :to => 'application#raise_not_found!'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
