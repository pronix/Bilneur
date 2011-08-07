class AddAdditionalDescriptionToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :additional_description, :text
  end

  def self.down
    remove_column :products, :additional_description
  end
end
