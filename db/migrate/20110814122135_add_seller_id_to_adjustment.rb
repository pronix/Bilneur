class AddSellerIdToAdjustment < ActiveRecord::Migration
  def self.up
    add_column :adjustments, :seller_id, :integer
    add_index :adjustments, :seller_id
  end

  def self.down
    remove_index :adjustments, :seller_id
    remove_column :adjustments, :seller_id
  end
end
