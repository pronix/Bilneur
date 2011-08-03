class AddOwnerToOptionType < ActiveRecord::Migration
  def self.up
    add_column :option_types, :owner_id, :integer
    add_index :option_types, :owner_id
  end

  def self.down
    remove_index :option_types, :owner_id
    remove_column :option_types, :owner_id
  end
end
