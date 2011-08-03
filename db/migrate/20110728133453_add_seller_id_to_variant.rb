class AddSellerIdToVariant < ActiveRecord::Migration
  def self.up
    add_column :variants, :seller_id, :integer
    add_index :variants, :seller_id
  end

  def self.down
    remove_index :variants, :seller_id
    remove_column :variants, :seller_id
  end
end
