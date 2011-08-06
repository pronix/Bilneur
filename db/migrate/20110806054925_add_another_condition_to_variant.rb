class AddAnotherConditionToVariant < ActiveRecord::Migration
  def self.up
    add_column :variants, :another_condition, :string
  end

  def self.down
    remove_column :variants, :another_condition
  end
end
