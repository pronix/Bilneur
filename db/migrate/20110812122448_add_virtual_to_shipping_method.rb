class AddVirtualToShippingMethod < ActiveRecord::Migration
  def self.up
    add_column :shipping_methods, :virtual, :boolean, :default => false
    add_index :shipping_methods, :virtual
    ShippingMethod.update_all(:virtual => false) if Product.table_exists?
  end

  def self.down
    remove_index :shipping_methods, :virtual
    remove_column :shipping_methods, :virtual
  end
end
