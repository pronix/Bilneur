class AddSellerIdToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :seller_id, :integer
    add_index :orders, :seller_id
  end

  def self.down
    remove_index :orders, :seller_id
    remove_column :orders, :seller_id
  end
end
