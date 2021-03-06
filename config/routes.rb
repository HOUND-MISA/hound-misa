Rails.application.routes.draw do
  root 'pages#index'
  resources :tags
  resources :ads
  resources :events, except: [:new, :edit]
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks", :registrations => "registrations", :sessions => "sessions"}
    devise_scope :user do
      get 'users/sign_out' => "devise/sessions#destroy"
  end
  get '/join/:id', to: "event_attendees#join", as: :join_event
  get '/leave/:id', to: "event_attendees#leave", as: :leave_event
  get '/approve/:id', to: "events#approve", as: :approve_event
  get '/reject/:id', to: "events#reject", as: :reject_event
  get '/search', to:"events#search", as: :search
  get '/about', to: "pages#about", as: :about
  get '/error', to: "pages#pie", as: :pie
  get '/admin-dashboard', to: "pages#dashboard", as: :admin_dashboard
  get '/login_fail', to: "pages#fail", as: :login_fail
  
  #users
  get '/hound_users', to: "users#index", as: :hound_users
  get '/hound_users/:id/edit', to: "users#edit", as: :edit_hound_user
  get '/hound_users/:id/events', to: "users#events", as: :hound_user_events
  get '/hound_users/:id', to: "users#show", as: :hound_user
  delete '/hound_users/:id', to: "users#destroy"

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
