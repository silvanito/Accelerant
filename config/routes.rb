ActionController::Routing::Routes.draw do |map|
  map.resources :wysihat_files


  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.add_user '/add_user', :controller => 'users', :action => 'add'
  map.plain '/plain', :controller => 'plain', :action => 'showlatest'
  map.resources :users, :has_many => :comments
  map.resources :comments, :belongs_to => :users, :has_many => :subcomments
  map.resources :report_comments
  map.update_report_flag '/comments/update_report_flag', :controller => "comments", :action => "update_report_flag", :method => :post
  map.report_coments '/comments/report_comments/:id', :controller => "comments", :action => "report_comments"
  map.show_image '/comments/show_image', :controller => "comments", :action => "show_image/:id"
  map.resources :replies, :belongs_to => :comments
  map.update_report_flag '/replies/add_to_report', :controller => "replies", :action => "add_to_report", :method => :post
  map.show_image '/replies/show_image', :controller => "replies", :action => "show_image/:id"
  map.resources :subcomments, :belongs_to => :comments
  map.resources :client, :has_many => :projects
  map.resources :project, :has_many => :assignments
  map.show_image '/project/show_image', :controller => "project", :action => "show_image/:id"
  map.resources :assignment, :has_many => :participants
  map.resources :discussion, :belongs_to => :projects
  map.resources :discussion, :belongs_to => :projects, :has_many => :flex_modules
  map.discussion_show 'discussion_show', :controller => "discussion", :action => "discussion_show"
  map.discussion_show 'discussion_show.:format', :controller => "discussion", :action => "discussion_show"
  map.show_image '/discussion/show_image', :controller => "discussion", :action => "show_image/:id"
  map.comment '/comment', :controller => 'comment', :action => 'show'
  map.comment_heatmap '/comment_heatmap', :controller=>"comments", :action => "comment_heatmap"
  map.importer '/importer', :controller => 'importer', :action => 'index'
  map.resources :users
  map.resources :themes, :belongs_to => :project
  map.resources :sortableitems, :collection => {:sort => :post}

  map.resources :comments, :collection => {:reorder => :post}
  map.resources :groupableitems, :collection => {:group => :post}
  map.resources :usersortables, :collection => {:sort => :post}
  map.resources :sortables, :collection => {:sort => :post}
  map.online '/online', :controller => 'users', :action => 'showsessions'
  map.your_users '/your_users', :controller => 'users', :action => 'your_users'
  map.admin_report '/admin_report.:format', :controller => 'discussion', :action => 'admin_report'
  map.resources  :heatmap, :only => "create"
  map.resources :categories, :member => {:unassign => :get, :assigned => :get}
  map.assign '/category/:id/assign', :controller => "categories", :action => "assign"
  map.resource :session
  map.resources :module_types
  map.resources :flex_modules  do |flex_module|
    flex_module.resources :module_images
    flex_module.resources :module_responses
    flex_module.resources  :module_response_images, :only => :create
  end
  map.get_module '/module_responses/get_module.:format', :controller => "module_responses", :action => "get_module"
  map.flex_module_change_status '/flex_modules/change_status.:format', :controller => "flex_modules", :action => "change_status"
  #map.root :controller => 'sessions', :action => 'new'
  map.root :controller => 'start', :action => 'index'

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
