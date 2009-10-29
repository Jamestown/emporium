class Admin::BooksController < ApplicationController
  
  def index
    list
    render :action => 'list'
  end
  
  def list
    @page_title = 'Listing books'
    sort_by = params[:sort_by]
    #@books = Book.all
    @books = Book.paginate :per_page => 5, :page => params[:page], :order => sort_by
  end
  
  def show
    @book = Book.find(params[:id])
    load_data
    @page_title = "#{@book.title}"
  end
  
  def new
    load_data
    @book = Book.new
  end
  
  def edit
    @book = Book.find(params[:id])
    load_data
    @page_title = "Editing book #{@book.title}"
  end
  
  def create
    @book = Book.new(params[:book])
    
    if @book.save
      flash[:notice] = 'Book was successfully created.'
      redirect_to :action => 'list'
    else
      load_data
      render :action => 'new'
    end
  end
  
  def update
    @book = Book.find(params[:id])
    if @book.update_attributes(params[:book])
      flash[:notice] = 'Book was successfully updated.'
      redirect_to :action => 'show', :id => @book
    else
      render :action => 'edit'
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    
    redirect_to :action => 'list'
  end
  
  private
    
    def load_data
      @authors = Author.find(:all)
      @publishers = Publisher.find(:all)
    end
  
end
