class AddWarehouseToVariant < ActiveRecord::Migration
  def self.up
    add_column :variants, :warehouse, :string, :default => "merchant"
    add_index :variants, :warehouse
    if ::Product.table_exists?
      Variant.where("virtual != ?", true).update_all(:warehouse => "merchant" )
      Variant.where(:virtual => true).update_all(:warehouse => "bilneur" )
      SellerStore.all.map{ |v| v.variant.update_attribute(:warehouse, "seller")}
    end
  end

  def self.down
    remove_index :variants, :warehouse
    remove_column :variants, :warehouse
  end
end
