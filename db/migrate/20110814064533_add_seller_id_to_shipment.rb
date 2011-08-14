class AddSellerIdToShipment < ActiveRecord::Migration
  def self.up
    add_column :shipments, :seller_id, :integer
    add_index :shipments, :seller_id
  end

  def self.down
    remove_index :shipments, :seller_id
    remove_column :shipments, :seller_id
  end
end
