class CreateVirtualOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :virtual, :boolean, :default => false
    add_index :orders, :virtual
    Order.unscoped.all.map{ |v| v.update_attribute(:virtual, false)}
  end

  def self.down
    remove_index :orders, :virtual
    remove_index :orders, :column
  end
end
