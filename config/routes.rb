ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => 'catalog', :action => 'index'
  
  map.about 'about/', :controller => 'about', :action => 'index'
  map.search 'catalog/search', :controller => 'catalog', :action => 'search'
  map.latest 'catalog/latest', :controller => 'catalog', :action => 'latest'
  map.rss_feed 'catalog/rss', :controller => 'catalog', :action => 'rss', :format => 'xml'
  
  map.namespace('admin') do |admin|
    admin.resources :authors,  :controller => 'author'
    admin.resources :publishers, :controller => 'publisher'
    admin.resources :books, :controller => 'books', :collection => {:list => :get}
  end
  
  map.resources 'catalog'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end