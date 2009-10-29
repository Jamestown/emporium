class CreatePublishers < ActiveRecord::Migration
  def self.up
    create_table :publishers do |t|
      t.column :name, :string, :limit => 255, :null => false,
        :unique => true
      t.timestamps
    end
  end

  def self.down
    drop_table :publishers
  end
end
