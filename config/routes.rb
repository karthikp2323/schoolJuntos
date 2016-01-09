Rails.application.routes.draw do

  get 'api/school_users/getClassList', to: 'api/school_users#getClassList'

  #post 'api/activities/create', to: 'api/activities#create'

  namespace :api do
    resources :school_users
  end

  namespace :api do
    resources :activities
  end
  
  get 'api/home/attempt_login', to: 'api/home#attempt_login'



  get 'school_users/teacherHomeView', to: 'school_users#teacherHomeView'
  
  get 'home/logout', to: 'home#logout'

  post 'check_login' => 'home#check_login'

  #devise_for :users
  resources :parents
  resources :activities
  resources :classrooms
  resources :students
  resources :school_users
  resources :schools
  #resources :home

  


  match ':controller(/:action(/:id))', :via => :post


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'home#login'

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
