class AddOwnerToVariant < ActiveRecord::Migration
  def self.up
    add_column :variants, :owner_id, :integer
    add_column :variants, :virtual, :boolean, :default => false

    add_index :variants, :owner_id
    add_index :variants, :virtual
    if Product.table_exists?
      Variant.all.each do |item|
        item.update_attributes({ :virtual => false, :owner => item.seller})
      end
    end
  end

  def self.down
    remove_index  :variants, :owner_id
    remove_index  :variants, :virtual

    remove_column :variants, :owner_id
    remove_column :variants, :virtual

  end
end
