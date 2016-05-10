Rails.application.routes.draw do
  concern  :votable do
    member do #Create actually calls the CRUD method which figures out whether to Create, Update or Destroy the vote.
      get 'vote_up'
      get 'vote_down'
    end
  end
  resources :positions, except: [:new, :create], concerns: :votable
  
 

  resources :discussions, concerns: :votable do
    resources :positions, only: [:new, :create]
  end
  
  resources :users do
    resources :discussions
    member do
      get 'positions'
    end
  end
  
  
  #Speecial interactions with resources
  get 'users_by/email' => 'users#by_email'

  #Login / Logout options
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  get 'signup' => 'users#new'
  get 'home' => 'home#stories'
  
  
  
  root 'sessions#redirect'
  

  #  namespace :api do
  #    namespace :v1 do
  #
  #      resources :discussions, shallow:true
  #
  #   end
  #  end
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
