class AddGroupSaleIdToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :group_sale_id, :integer
    add_index :orders, :group_sale_id
  end

  def self.down
    remove_index :orders, :group_sale_id
    remove_column :orders, :group_sale_id
  end
end
