class AddIntConditionToVariant < ActiveRecord::Migration
  def self.up
    add_column :variants, :condition_int, :integer
   Variant.all.map(&:set_int_condition!) if Product.table_exists?
  end

  def self.down
    remove_column :variants, :condition_int
  end
end
