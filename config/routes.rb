ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  map.namespace('admin') do |admin|
    admin.resources :authors, :path_prefix => 'admin', :controller => 'author'
    admin.resources :publishers, :path_prefix => 'admin', :controller => 'publisher'
  end
  
  map.about 'about/', :controller => 'about', :action => 'index'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
