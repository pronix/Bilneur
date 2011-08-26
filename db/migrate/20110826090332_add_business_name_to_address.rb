class AddBusinessNameToAddress < ActiveRecord::Migration
  def self.up
    add_column :addresses, :business_name, :string
  end

  def self.down
    add_column :addresses, :business_name
  end
end
