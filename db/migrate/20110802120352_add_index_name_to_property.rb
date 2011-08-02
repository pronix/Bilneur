class AddIndexNameToProperty < ActiveRecord::Migration
  def self.up
    add_index :properties, :name, :unique => true
  end

  def self.down
    remove_index :properties, :name, :unique => true
  end
end
