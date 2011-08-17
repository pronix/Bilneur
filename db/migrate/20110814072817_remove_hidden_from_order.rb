class RemoveHiddenFromOrder < ActiveRecord::Migration
  def self.up
   remove_column :orders, :hidden
  end


  def self.down
   add_column :orders, :hidden, :boolean, :deafult => false
  end
end
