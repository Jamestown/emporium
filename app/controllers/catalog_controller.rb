class CatalogController < ApplicationController
  
  def index
    @page_title = 'Book list'
    @books = Book.paginate :per_page => per_page, :page => params[:page],
      :include => [:authors, :publisher], :order => 'books.id DESC'
  end

  def show
    @book = Book.find(params[:id]) rescue nil
    return render(:text => 'Not Found', :status => 404) unless @book
    @page_title = @book.title
  end

  def search
    @page_title = 'Search'
    if params[:commit] == 'Search' || params[:q]
      @books = Book.find_with_ferret(params[:q].to_s.upcase)
      unless @books.size > 0
        flash.now[:notice] = 'No books found matching your criteria'
      end
    end
  end

  def latest
    @page_title = 'Latest books'
    @books = Book.latest
  end
  
  def rss
    latest
    
    respond_to do |format|
      format.xml { render :layout => false }
    end
  end
  
  protected
    
    cattr_reader :per_page
    @@per_page = 10

end
