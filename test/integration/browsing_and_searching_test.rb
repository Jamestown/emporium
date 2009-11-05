require 'test_helper'

class BrowsingAndSearchingTest < ActionController::IntegrationTest
  fixtures :all
  
  def test_browsing_the_site
    jill = enter_site(:jill)
    jill.browse_index
    jill.go_to_page(2)
  end
  
  def test_getting_details
    jill = enter_site(:jill)
    jill.get_book_details_for 'Pride and Prejudice'
    jill.searches_for_tolstoy
    jill.views_latest_books
    jill.reads_rss
  end
  
  private
    
    module BrowsingTestDSL
      attr_writer :name
      
      def browse_index
        get '/catalog'
        
        assert_response :success
        assert_template 'catalog/index'
        assert_tag :tag => 'dl', :attributes => {:id => 'books'},
          :children => {:count => 10, :only => {:tag => 'dt'}}
        assert_select 'dt', :content => 'The Idiot'
        check_book_links
      end
      
      def go_to_page(page)
        get "/catalog?page=#{page}"
        assert_response :success
        assert_template 'catalog/index'
        assert_equal Book.find_by_title('Pro Rails E-Commerce'),
          assigns(:books).last
        check_book_links
      end
      
      def get_book_details_for(title)
        @book = Book.find_by_title(title)
        get "/catalog/#{@book.id}"
        assert_response :success
        assert_template 'catalog/show'
        
        assert_tag :tag => 'h1', :content => @book.title
        assert_tag :tag => 'h2', :content => "by #{@book.authors.map {|a| a.name}.join(', ')}"
      end
      
      def check_book_links
        for book in assigns(:books)
          assert_tag :tag => 'a', :attributes => {:href => "/catalog/#{book.id}"}
        end
      end
      
      def searches_for_tolstoy
        leo = Author.find_by_first_name_and_last_name('Leo', 'Tolstoy')
        
        get "/catalog/search?q=#{url_encode('Leo Tolstoy')}"
        assert_response :success
        assert_template 'catalog/search'
        
        assert_tag :tag => 'dl', :attributes => {:id => 'books'},
          :children => {:count => leo.books.size, :only => {:tag => 'dt'}}
        
        leo.books.each do |book|
          assert_tag :tag => 'dt', :content => book.title
        end
      end
      
      def views_latest_books
        get '/catalog/latest'
        assert_response :success
        assert_template 'catalog/latest'
        
        assert_tag :tag => 'dl', :attributes => {:id => 'books'},
          :children => {:count => 10, :only => {:tag => 'dt'}}
        
        Book.latest.each do |book|
          assert_tag :tag => 'dt', :content => book.title
        end
      end
      
      def reads_rss
        get '/catalog/rss'
        assert_response :success
        assert_template 'catalog/rss'
        assert_equal 'application/xml', response.content_type
        
        assert_tag :tag => 'channel',
          :children => {:count => 10, :only => {:tag => 'item'}}
        
        Book.latest.each do |book|
          assert_tag :tag => 'title', :content => book.title
        end
      end
      
    end
    
    def enter_site(name)
      open_session do |session|
        session.extend(BrowsingTestDSL)
        session.name = name
        yield session if block_given?
      end
    end
  
end