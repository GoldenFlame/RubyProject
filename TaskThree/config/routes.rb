TaskThree::Application.routes.draw do
 
  get "user/login"
  get "user/authenticate"
  get "user/private"
  get "user/logout"
  get "avatar/inventory"
  get "avatar/item"
  match "avatar/item/:avatar_item" => "avatar#item", :as => "item"
  match "fights/area" => "fight#area", :as => "fight_wilds"
  match "avatar/equip/:item" => "avatar#equip"
  match "avatar/disequip" => "avatar#disequip"
  match "fights/user_action" => "fight#user_action"
  match "fights/check_fight_end" => "fight#check_fight_end", :as => "check_fight_end"
  match "cities/wilds" => "cities#wilds", :as => "wilds"
  match "cities/shop" => "cities#shop", :as => "shop"
  match "cities/inn" => "cities#inn", :as => "inn"
  match "avatar/travel" => "avatar#travel", :as => "travel"
  match "avatar/stats" => "avatar#stats", :as => "stats"
  match "avatar/inventory" => "avatar#inventory", :as => "inventory"
  match "shops" => "shops#index"
  match "shops/buy" => "shops#buy"
  match "shops/sell" => "shops#sell"
  match "shops/view/:item/:for" => "shops#view", :as => "view_item"
  match "shops/buy_item/:item" => "shops#buy_item", :as => "buy_item"
  match "shops/sell_item/:item" => "shops#sell_item", :as => "sell_item"
  
  root :to => "user#login"
  #match 'items/:id' => 'items#index'
  #match 'ts/3' => 'application#show'
  
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
