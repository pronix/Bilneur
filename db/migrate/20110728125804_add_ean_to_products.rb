class AddEanToProducts < ActiveRecord::Migration

  def self.up
    add_column :products, :ean, :string, :null => false
    add_index  :products, :ean, :unique => true
  end

  def self.down
    remove_index  :products, :ean
    remove_column :products, :ean
  end

end
