class AddReceiveAtToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :receive_at, :datetime
  end

  def self.down
    remove_column :orders, :receive_at
  end
end
