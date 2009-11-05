require 'test_helper'

class BookTest < ActionController::IntegrationTest
  fixtures :all

  def test_book_administration
    publisher = Publisher.create(:name => 'Books for Dummies')
    author = Author.create(:first_name => 'Bodo', :last_name => 'Bar')
    
    george = new_session_as(:george)
    ruby_for_dummies = george.add_book :book => {
      :title => 'Ruby for Dummies',
      :publisher_id => publisher.id,
      :author_ids => [author.id],
      :published_at => Time.now,
      :isbn => '123-123-123-X',
      :blurb => 'The best book released since "Eating for Dummies"',
      :page_count => 123,
      :price => 40.4
    }
    
    george.list_books
    george.show_book ruby_for_dummies
    
    george.edit_book(ruby_for_dummies, :book => {
      :title => 'Ruby for Toddlers',
      :publisher_id => publisher.id,
      :author_ids => [author.id],
      :published_at => Time.now,
      :isbn => '123-123-123-Z',
      :blurb => 'The best book released since "Eating for Toddlers"',
      :page_count => 123,
      :price => 40.4
    })
    
    bob = new_session_as(:bob)
    bob.delete_book ruby_for_dummies
  end
  
  private
    module BookTestDSL
      attr_writer :name
      
      def list_books
        get '/admin/books/list'
        assert_response :success
        assert_template 'admin/books/list'
      end
      
      def add_book(parameters)
        author = Author.find(:all).first
        publisher = Publisher.find(:all).first
        
        get '/admin/books/new'
        assert_response :success
        assert_template 'admin/books/new'
        
        assert_tag :tag => 'option', :attributes => {:value => publisher.id}
        assert_tag :tag => 'select', :attributes => 
          {:name => 'book[author_ids][]', :multiple => 'multiple'}
        
        post '/admin/books/create', parameters
        assert_response :redirect
        follow_redirect!
        assert_response :success
        assert_template 'admin/books/list'
        assert_tag :tag => 'td', :content => parameters[:book][:title]
        
        return Book.find_by_title(parameters[:book][:title])
      end
      
      def show_book(book)
        get "/admin/books/#{book.id}"
        assert_response :success
        assert_template 'admin/books/show'
      end
      
      def edit_book(book, parameters)
        get "/admin/books/#{book.id}/edit"
        assert_response :success
        assert_template 'admin/books/edit'
        
        put "/admin/books/#{book.id}", parameters
        assert_response :redirect
        follow_redirect!
        assert_response :success
        assert_template 'admin/books/show'
      end
      
      def delete_book(book)
        delete "/admin/books/#{book.id}"
        assert_response :redirect
        follow_redirect!
        assert_response :success
        assert_template 'admin/books/list'
      end
    end
    
    def new_session_as(name)
      open_session do |session|
        session.extend(BookTestDSL)
        session.name = name
        yield session if block_given?
      end
    end
  
end
