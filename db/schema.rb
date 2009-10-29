# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091028043817) do

  create_table "authors", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authors_books", :id => false, :force => true do |t|
    t.integer "author_id", :null => false
    t.integer "book_id",   :null => false
  end

  add_index "authors_books", ["author_id"], :name => "fk_bk_authors"
  add_index "authors_books", ["book_id"], :name => "fk_bk_books"

  create_table "books", :force => true do |t|
    t.string   "title",                      :null => false
    t.integer  "publisher_id",               :null => false
    t.datetime "published_at"
    t.string   "isbn",         :limit => 13
    t.text     "blurb"
    t.integer  "page_count"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "books", ["publisher_id"], :name => "fk_books_publishers"

  create_table "publishers", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
