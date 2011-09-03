class AddActiveToVariant < ActiveRecord::Migration
  def self.up
    add_column :variants, :active, :boolean, :default => true
    add_index :variants, :active
    Variant.update_all(:active => true) if ::Variant.table_exists?
  end

  def self.down
    remove_index :variants, :active
    remove_column :variants, :active
  end
end
