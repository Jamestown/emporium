class CreateBooksAndAuthorsBooks < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.column :title, :string, :limit => 255, :null => false
      t.column :publisher_id, :integer, :null => false
      t.column :published_at, :datetime
      t.column :isbn, :string, :limit => 13, :unique => true
      t.column :blurb, :text
      t.column :page_count, :integer
      t.column :price, :float
      
      t.timestamps
    end
    
    create_table :authors_books, :id => false do |t|
      t.column :author_id, :integer, :null => false
      t.column :book_id, :integer, :null => false
    end
    
    say_with_time 'Adding foreign keys' do
      # Add foreign key reference to books_authors table:
      execute 'ALTER TABLE authors_books ADD CONSTRAINT fk_bk_authors 
        FOREIGN KEY (author_id) REFERENCES authors(id) ON DELETE CASCADE'
      execute 'ALTER TABLE authors_books ADD CONSTRAINT fk_bk_books 
        FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE'
      
      # Add foreign key reference to publishers table:
      execute 'ALTER TABLE books ADD CONSTRAINT fk_books_publishers 
        FOREIGN KEY (publisher_id) REFERENCES publishers(id) ON DELETE CASCADE'
    end
    
  end

  def self.down
    drop_table :authors_books
    drop_table :books
  end
end
