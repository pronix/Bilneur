class AddParentIdToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :parent_id, :integer
    add_index  :orders, :parent_id
  end

  def self.down
    remove_index :orders, :parent_id
    remove_column :orders, :parent_id
  end
end
