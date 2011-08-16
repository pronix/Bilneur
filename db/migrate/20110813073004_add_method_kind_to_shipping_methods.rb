class AddMethodKindToShippingMethods < ActiveRecord::Migration
  def self.up
    add_column :shipping_methods, :method_kind, :string, :default => 'to_address'
    add_index :shipping_methods, :method_kind
    ShippingMethod.update_all(:method_kind => 'to_address') if Product.table_exists?
  end

  def self.down
    remove_index :shipping_methods, :method_kind
    remove_column :shipping_methods, :method_kind
  end
end
