class AddNameToVariant < ActiveRecord::Migration
  def self.up
    add_column :variants, :name, :string
  end

  def self.down
    remove_column :variants, :name
  end
end
