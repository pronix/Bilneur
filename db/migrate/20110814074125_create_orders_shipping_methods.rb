class CreateOrdersShippingMethods < ActiveRecord::Migration
  def self.up
    create_table :orders_shipping_methods, :id => false do |t|
      t.references :shipping_method
      t.references :order
    end
    add_index :orders_shipping_methods, :order_id
    add_index :orders_shipping_methods, :shipping_method_id

  end

  def self.down
    remove_index :orders_shipping_methods, :order_id
    remove_index :orders_shipping_methods, :shipping_method_id
    drop_table :orders_shipping_methods
  end
end
