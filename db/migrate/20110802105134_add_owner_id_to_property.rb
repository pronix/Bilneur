class AddOwnerIdToProperty < ActiveRecord::Migration
  def self.up
    add_column :properties, :owner_id, :integer
    add_index :properties, :owner_id
  end

  def self.down
    remove_index :properties, :owner_id
    remove_column :properties, :owner_id
  end
end
