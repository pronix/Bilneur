class AddOperationTypeToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :operation_type, :string, :default => "simple"
    add_index :orders, :operation_type
    Order.update_all(:operation_type => "simple") if ::Order.table_exists?
  end

  def self.down
    remove_index :orders, :operation_type
    remove_column :orders, :operation_type
  end
end
