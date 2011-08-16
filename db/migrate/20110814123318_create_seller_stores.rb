class CreateSellerStores < ActiveRecord::Migration
  def self.up
    create_table :seller_stores do |t|
      t.integer :seller_id
      t.integer :dealer_id
      t.integer :variant_id
      t.integer :quote_id
      t.integer :order_id
      t.integer :quantity

      t.timestamps
    end

    add_index :seller_stores, :seller_id
    add_index :seller_stores, :dealer_id
    add_index :seller_stores, :variant_id
    add_index :seller_stores, :quote_id
    add_index :seller_stores, :order_id
  end

  def self.down

    remove_index :seller_stores, :seller_id
    remove_index :seller_stores, :dealer_id
    remove_index :seller_stores, :variant_id
    remove_index :seller_stores, :quote_id
    remove_index :seller_stores, :order_id
    drop_table :seller_stores
  end
end
