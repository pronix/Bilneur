class AddSellerToShippingMethods < ActiveRecord::Migration

  def self.up
    add_column :shipping_methods, :seller_id, :integer
    add_index :shipping_methods, :seller_id
  end

  def self.down
    remove_index :shipping_methods, :seller_id
    remove_column :shipping_methods, :seller_id
  end

end
