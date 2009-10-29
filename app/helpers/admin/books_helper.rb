module Admin::BooksHelper
  def author_list(book)
    book.authors.collect{|author| author.name}.join(', ')
  end
end
