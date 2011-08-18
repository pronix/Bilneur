class AddPrimaryMarkToAddress < ActiveRecord::Migration
  def self.up
    add_column :addresses, :primary, :boolean, :default => false
    User.all.map{|v| 
      if (@primary_address = v.addresses.first)
         @primary_address.update_attribute(:primary, true)
      end
    } if User.table_exists?
  end

  def self.down
    remove_column :addresses, :primary
  end
end
