FundTracker::Application.routes.draw do

  get "series/index" => "series#index", :as => 'series'

  get 'log_in' => "auth#new", :as => 'log_in'
  get 'log_out' => "auth#destroy", :as => 'log_out'
  
  get 'forgot_password' => "auth#forgot_password_form", :as => 'forgot_password_form'
  post 'password_recovery' => "auth#set_password_recovery_hash", :as => 'password_recovery'
  
  get 'reset_password_form/:user_id/:recovery_hash' => "auth#reset_password_form", :as => 'reset_password_form'
  put 'reset_password' => "auth#reset_password", :as => 'reset_password'
  
  root :to => "dashboard#index"
  
  resources :users do 
    get 'edit_profile'
    put 'update_profile'
  end
  
  resources :auth
  resources :companies
  resources :documents
  resources :period_results do
    put :change_period
    put :change_view_type
  end
  resources :operationals do
    put :change_period
  end
  resources :series
  resources :funds
  resources :organizations
  
  resources :companies do
    resources :documents
    resources :series
    resources :period_results do
      get :move_through_time
    end
    resources :user_defined_categories
    resources :operationals do
      get :move_through_time
    end
  end
  
  namespace "admin" do
    resources :organizations do
      resources :funds do
        resources :companies
      end
    end
    resources :companies do
      resources :series
      resources :operationals
      resources :period_results
      resources :forecasts
      resources :user_defined_categories
    end
    
    resources :period_results do
      resources :custom_cells
    end
    
    resources :users do
      get 'edit_profile'
      put 'update_profile'
    end
  end 
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"
  
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
