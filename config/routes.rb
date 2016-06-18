Rails.application.routes.draw do
  concern  :votable do
    member do #Create actually calls the CRUD method which figures out whether to Create, Update or Destroy the vote.
      get 'vote_up'
      get 'vote_down'
    end
  end
  
  concern :commentable do
    resources :comments, only: [:create, :index] do
      collection do
        get 'get_all'
      end
    end
  end
  
  resources :discussions, only: [:new, :create] do #Allowed creating new items only from logged user
  end
  
  resources :comments, concerns: [:votable, :commentable]
  
  resources :users do
    collection do
      get 'by_email'
    end
    resources :positions, only: [:index] do
      #TODO allow showing all positions / Change current index to collection action 'invitations' and restore normal index functionality
    end
    resources :discussions, except: [:new, :create], shallow: true, concerns: [:votable, :commentable] do 
      member do
        get 'publish'
      end
      resources :positions, shallow: true, concerns: [:votable, :commentable] do
        collection do
          post 'new_token'
        end
      end
    end
  end
  
  #Login / Logout options
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  
  get 'signup' => 'users#new'
  
  delete 'logout' => 'sessions#destroy'
  
  get 'auth/:provider', to: redirect('/auth/%{provider}'), as: :social_login
  get 'auth/:provider/callback', to: 'sessions#oauthcreate'
  get 'auth/failure', to: redirect('/')
  
  get 'home' => 'home#stories'

  root 'sessions#redirect'
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
