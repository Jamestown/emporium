ActionController::Routing::Routes.draw do |map|
  map.namespace('admin') do |admin|
    admin.resources :authors,  :controller => 'author'
    admin.resources :publishers, :controller => 'publisher'
    admin.resources :books, :controller => 'books', :collection => {:list => :get}
  end
  
  map.root :controller => 'admin/books', :action => 'index'
  map.about 'about/', :controller => 'about', :action => 'index'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end