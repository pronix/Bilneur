class AddAdditionallyFieldsToVariant < ActiveRecord::Migration

  def self.up
    add_column :variants, :condition, :string
    add_column :variants, :description, :text
  end

  def self.down
    remove_column :variants, :description
    remove_column :variants, :condition
  end

end
